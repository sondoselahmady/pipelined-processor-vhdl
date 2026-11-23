library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processor is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        obs_pc          : out std_logic_vector(31 downto 0);
        obs_mux4_out    : out std_logic_vector(31 downto 0);
        obs_muxi_out    : out std_logic_vector(31 downto 0);
        obs_mux2_out    : out std_logic_vector(17 downto 0);
        obs_muxa_out    : out std_logic_vector(31 downto 0);
        obs_muxb_out    : out std_logic_vector(31 downto 0);
        obs_ar          : out std_logic_vector(17 downto 0);
        obs_alu_result  : out std_logic_vector(31 downto 0);
        obs_mem_out     : out std_logic_vector(31 downto 0);
        obs_rf_wr_en    : out std_logic;
        obs_rf_wr_addr  : out std_logic_vector(2  downto 0);
        obs_rf_wr_data  : out std_logic_vector(31 downto 0);
        obs_psw_z, obs_psw_s, obs_psw_v, obs_psw_c : out std_logic;
        obs_branch_taken: out std_logic;
        obs_op_if, obs_op_id, obs_op_ear, obs_op_fo, obs_op_ex : out std_logic_vector(5 downto 0);
        obs_r1, obs_r2, obs_r3, obs_r4, obs_r5, obs_r6, obs_r7 : out std_logic_vector(31 downto 0)
    );
end entity processor;

architecture structural of processor is

    component instruction_memory port(addr:in std_logic_vector(7 downto 0); data:out std_logic_vector(31 downto 0)); end component;
    component if_id port(clk,rst:in std_logic; instr_in,pc_in:in std_logic_vector(31 downto 0); instr_out,pc_out:out std_logic_vector(31 downto 0)); end component;
    component control_unit port(instr:in std_logic_vector(31 downto 0); SELA,SELB:out std_logic_vector(3 downto 0); SELD:out std_logic_vector(2 downto 0); SELI,OPR:out std_logic_vector(3 downto 0); MR,MW,MS,MI,BR,JT:out std_logic); end component;
    component register_file port(clk,rst:in std_logic; wr_en:in std_logic; wr_addr:in std_logic_vector(2 downto 0); wr_data:in std_logic_vector(31 downto 0); reg_out:out std_logic_vector(255 downto 0)); end component;
    component mux_2to1 generic(WIDTH:integer:=32); port(sel:in std_logic; m0,m1:in std_logic_vector(WIDTH-1 downto 0); y:out std_logic_vector(WIDTH-1 downto 0)); end component;
    component mux_16to1 generic(WIDTH:integer:=32); port(sel:in std_logic_vector(3 downto 0); m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15:in std_logic_vector(WIDTH-1 downto 0); y:out std_logic_vector(WIDTH-1 downto 0)); end component;
    component alu port(opr:in std_logic_vector(3 downto 0); a,b:in std_logic_vector(31 downto 0); result:out std_logic_vector(31 downto 0); z_flag,s_flag,v_flag,c_flag:out std_logic); end component;
    component psw port(clk,rst:in std_logic; v_in,s_in,c_in,z_in:in std_logic; v_flag,s_flag,c_flag,z_flag:out std_logic); end component;
    component data_memory port(clk:in std_logic; rd_addr:in std_logic_vector(17 downto 0); rd_en:in std_logic; rd_data:out std_logic_vector(31 downto 0); wr_addr:in std_logic_vector(17 downto 0); wr_data:in std_logic_vector(31 downto 0); wr_en:in std_logic); end component;
    component id_ear port(clk,rst:in std_logic; sela_in,selb_in:in std_logic_vector(3 downto 0); seld_in:in std_logic_vector(2 downto 0); seli_in,opr_in:in std_logic_vector(3 downto 0); mr_in,mw_in,ms_in,mi_in,br_in,jt_in:in std_logic; instr_in,pc_in:in std_logic_vector(31 downto 0); sela_out,selb_out:out std_logic_vector(3 downto 0); seld_out:out std_logic_vector(2 downto 0); seli_out,opr_out:out std_logic_vector(3 downto 0); mr_out,mw_out,ms_out,mi_out,br_out,jt_out:out std_logic; instr_out,pc_out:out std_logic_vector(31 downto 0)); end component;
    component ear_fo port(clk,rst:in std_logic; sela_in,selb_in:in std_logic_vector(3 downto 0); seld_in:in std_logic_vector(2 downto 0); opr_in:in std_logic_vector(3 downto 0); mr_in,mw_in:in std_logic; ea_in:in std_logic_vector(17 downto 0); imm_in,pc_in:in std_logic_vector(31 downto 0); offset_in:in std_logic_vector(17 downto 0); br_in,jt_in:in std_logic; sela_out,selb_out:out std_logic_vector(3 downto 0); seld_out:out std_logic_vector(2 downto 0); opr_out:out std_logic_vector(3 downto 0); mr_out,mw_out:out std_logic; ea_out:out std_logic_vector(17 downto 0); imm_out,pc_out:out std_logic_vector(31 downto 0); offset_out:out std_logic_vector(17 downto 0); br_out,jt_out:out std_logic); end component;
    component fo_ex port(clk,rst:in std_logic; seld_in:in std_logic_vector(2 downto 0); opr_in:in std_logic_vector(3 downto 0); mr_in,mw_in:in std_logic; ea_in:in std_logic_vector(17 downto 0); bus_a_in,bus_b_in,pc_in:in std_logic_vector(31 downto 0); br_in,jt_in:in std_logic; offset_in:in std_logic_vector(17 downto 0); imm_in:in std_logic_vector(31 downto 0); seld_out:out std_logic_vector(2 downto 0); opr_out:out std_logic_vector(3 downto 0); mr_out,mw_out:out std_logic; ea_out:out std_logic_vector(17 downto 0); bus_a_out,bus_b_out,pc_out:out std_logic_vector(31 downto 0); br_out,jt_out:out std_logic; offset_out:out std_logic_vector(17 downto 0); imm_out:out std_logic_vector(31 downto 0)); end component;
    component ex_mem_wb port(clk,rst:in std_logic; seld_in:in std_logic_vector(2 downto 0); mw_in:in std_logic; ea_in:in std_logic_vector(17 downto 0); alu_res_in,bus_a_in,bus_b_in:in std_logic_vector(31 downto 0); reg_wr_en:out std_logic; reg_wr_addr:out std_logic_vector(2 downto 0); reg_wr_data:out std_logic_vector(31 downto 0); mem_wr_en:out std_logic; mem_wr_addr:out std_logic_vector(17 downto 0); mem_wr_data:out std_logic_vector(31 downto 0)); end component;
    component decoder_3to8 port(seld:in std_logic_vector(2 downto 0); en:in std_logic; y:out std_logic_vector(7 downto 0)); end component;

    constant Z32 : std_logic_vector(31 downto 0) := (others=>'0');
    signal pc_cur, pc_next, pc_p1, instr_if, mux4_out_s, instr_id, pc_id : std_logic_vector(31 downto 0);
    signal cu_sela,cu_selb, cu_seli,cu_opr, ear_sela,ear_selb, ear_seli,ear_opr, fo_sela,fo_selb, fo_opr, ex_opr : std_logic_vector(3 downto 0);
    signal cu_seld, ear_seld, fo_seld, ex_seld, rf_wr_addr : std_logic_vector(2 downto 0);
    signal cu_mr,cu_mw,cu_ms,cu_mi,cu_br,cu_jt, ear_mr,ear_mw,ear_ms,ear_mi,ear_br,ear_jt, fo_mr,fo_mw,fo_br,fo_jt, ex_mr,ex_mw,ex_br,ex_jt : std_logic;
    signal ear_instr,ear_pc, imm_val, muxi_out_s, dmem_rd_data, fo_imm,fo_pc, muxa_out_s, muxb_out_s, ex_bus_a,ex_bus_b, ex_pc, ex_imm, alu_result, rf_wr_data, mem_wr_data, pc_offset, jump_addr : std_logic_vector(31 downto 0);
    signal reg_all : std_logic_vector(255 downto 0);
    signal r0,r1,r2,r3,r4,r5,r6,r7 : std_logic_vector(31 downto 0);
    signal rf_wr_en, dmem_rd_en, foex_mr_fb, alu_z,alu_s,alu_v,alu_c, psw_z,psw_s,psw_v,psw_c, mem_wr_en, branch_taken : std_logic;
    signal src2_raw, ar_s, fo_ea, fo_offset, ex_ea, ex_offset, mem_wr_addr, dmem_rd_addr : std_logic_vector(17 downto 0);
    signal fo_opcode_r, ex_opcode : std_logic_vector(5 downto 0);
    signal pc_sel : std_logic_vector(1 downto 0);
    signal dec_out : std_logic_vector(7 downto 0);

begin

    pc_p1 <= std_logic_vector(unsigned(pc_cur) + 1);
    pc_offset <= std_logic_vector(unsigned(ex_pc) + unsigned(resize(signed(ex_offset), 32)));
    jump_addr <= std_logic_vector(resize(unsigned(ex_offset), 32));
    imm_val <= std_logic_vector(resize(signed(ear_instr(17 downto 0)), 32));
    src2_raw <= ear_instr(17 downto 0);

    pc_sel <= ex_jt & branch_taken;
    pc_next <= pc_p1 when pc_sel = "00" else pc_offset when pc_sel = "01" else jump_addr when pc_sel = "10" else pc_p1;
    mux4_out_s <= pc_next;

    pc_reg: process(clk, rst) begin if rst = '1' then pc_cur <= (others => '0'); elsif rising_edge(clk) then pc_cur <= pc_next; end if; end process;
    p_op: process(clk, rst) begin if rst = '1' then fo_opcode_r <= (others=>'0'); ex_opcode <= (others=>'0'); elsif rising_edge(clk) then fo_opcode_r <= ear_instr(31 downto 26); ex_opcode <= fo_opcode_r; end if; end process;

    p_br: process(ex_br, ex_opcode, psw_z) variable vbeq, vbne : std_logic; begin
        if ex_opcode = "110001" then vbeq := '1'; else vbeq := '0'; end if;
        if ex_opcode = "110010" then vbne := '1'; else vbne := '0'; end if;
        branch_taken <= ex_br and ((psw_z and vbeq) or ((not psw_z) and vbne));
    end process;

    u_im: instruction_memory port map(addr=>pc_cur(7 downto 0), data=>instr_if);
    u_ifid: if_id port map(clk=>clk, rst=>rst, instr_in=>instr_if, pc_in=>pc_cur, instr_out=>instr_id, pc_out=>pc_id);
    u_cu: control_unit port map(instr=>instr_id, SELA=>cu_sela, SELB=>cu_selb, SELD=>cu_seld, SELI=>cu_seli, OPR=>cu_opr, MR=>cu_mr, MW=>cu_mw, MS=>cu_ms, MI=>cu_mi, BR=>cu_br, JT=>cu_jt);
    u_idear: id_ear port map(clk=>clk, rst=>rst, sela_in=>cu_sela, selb_in=>cu_selb, seld_in=>cu_seld, seli_in=>cu_seli, opr_in=>cu_opr, mr_in=>cu_mr, mw_in=>cu_mw, ms_in=>cu_ms, mi_in=>cu_mi, br_in=>cu_br, jt_in=>cu_jt, instr_in=>instr_id, pc_in=>pc_id, sela_out=>ear_sela, selb_out=>ear_selb, seld_out=>ear_seld, seli_out=>ear_seli, opr_out=>ear_opr, mr_out=>ear_mr, mw_out=>ear_mw, ms_out=>ear_ms, mi_out=>ear_mi, br_out=>ear_br, jt_out=>ear_jt, instr_out=>ear_instr, pc_out=>ear_pc);
    u_rf: register_file port map(clk=>clk, rst=>rst, wr_en=>rf_wr_en, wr_addr=>rf_wr_addr, wr_data=>rf_wr_data, reg_out=>reg_all);
    r0<=reg_all(31 downto 0); r1<=reg_all(63 downto 32); r2<=reg_all(95 downto 64); r3<=reg_all(127 downto 96); r4<=reg_all(159 downto 128); r5<=reg_all(191 downto 160); r6<=reg_all(223 downto 192); r7<=reg_all(255 downto 224);
    
    u_muxi: mux_16to1 port map(sel=>ear_seli, m0=>r0, m1=>r1, m2=>r2, m3=>r3, m4=>r4, m5=>r5, m6=>r6, m7=>r7, m8=>dmem_rd_data, m9=>imm_val, m10=>Z32, m11=>Z32, m12=>Z32, m13=>Z32, m14=>Z32, m15=>Z32, y=>muxi_out_s);
    u_mux2: mux_2to1 generic map(WIDTH => 18) port map(sel=>ear_ms, m0=>src2_raw, m1=>muxi_out_s(17 downto 0), y=>ar_s);

    -- D-MEM Addressing Mux fix
    dmem_rd_addr <= ear_instr(17 downto 0) when ear_mi = '1' else fo_ea;
    dmem_rd_en   <= ear_mi or fo_mr;

    u_dm: data_memory port map(clk=>clk, rd_addr=>dmem_rd_addr, rd_en=>dmem_rd_en, rd_data=>dmem_rd_data, wr_addr=>mem_wr_addr, wr_data=>mem_wr_data, wr_en=>mem_wr_en);
    u_earfo: ear_fo port map(clk=>clk, rst=>rst, sela_in=>ear_sela, selb_in=>ear_selb, seld_in=>ear_seld, opr_in=>ear_opr, mr_in=>ear_mr, mw_in=>ear_mw, ea_in=>ar_s, imm_in=>imm_val, offset_in=>ear_instr(17 downto 0), pc_in=>ear_pc, br_in=>ear_br, jt_in=>ear_jt, sela_out=>fo_sela, selb_out=>fo_selb, seld_out=>fo_seld, opr_out=>fo_opr, mr_out=>fo_mr, mw_out=>fo_mw, ea_out=>fo_ea, imm_out=>fo_imm, offset_out=>fo_offset, pc_out=>fo_pc, br_out=>fo_br, jt_out=>fo_jt);
    u_muxa: mux_16to1 port map(sel=>fo_sela, m0=>r0, m1=>r1, m2=>r2, m3=>r3, m4=>r4, m5=>r5, m6=>r6, m7=>r7, m8=>dmem_rd_data, m9=>fo_imm, m10=>Z32, m11=>Z32, m12=>Z32, m13=>Z32, m14=>Z32, m15=>Z32, y=>muxa_out_s);
    u_muxb: mux_16to1 port map(sel=>fo_selb, m0=>r0, m1=>r1, m2=>r2, m3=>r3, m4=>r4, m5=>r5, m6=>r6, m7=>r7, m8=>dmem_rd_data, m9=>fo_imm, m10=>Z32, m11=>Z32, m12=>Z32, m13=>Z32, m14=>Z32, m15=>Z32, y=>muxb_out_s);
    u_foex: fo_ex port map(clk=>clk, rst=>rst, seld_in=>fo_seld, opr_in=>fo_opr, mr_in=>fo_mr, mw_in=>fo_mw, ea_in=>fo_ea, bus_a_in=>muxa_out_s, bus_b_in=>muxb_out_s, pc_in=>fo_pc, br_in=>fo_br, jt_in=>fo_jt, offset_in=>fo_offset, imm_in=>fo_imm, seld_out=>ex_seld, opr_out=>ex_opr, mr_out=>ex_mr, mw_out=>ex_mw, ea_out=>ex_ea, bus_a_out=>ex_bus_a, bus_b_out=>ex_bus_b, pc_out=>ex_pc, br_out=>ex_br, jt_out=>ex_jt, offset_out=>ex_offset, imm_out=>ex_imm);
    u_alu: alu port map(opr=>ex_opr, a=>ex_bus_a, b=>ex_bus_b, result=>alu_result, z_flag=>alu_z, s_flag=>alu_s, v_flag=>alu_v, c_flag=>alu_c);
    u_psw: psw port map(clk=>clk, rst=>rst, v_in=>alu_v, s_in=>alu_s, c_in=>alu_c, z_in=>alu_z, v_flag=>psw_v, s_flag=>psw_s, c_flag=>psw_c, z_flag=>psw_z);
    u_exwb: ex_mem_wb port map(clk=>clk, rst=>rst, seld_in=>ex_seld, mw_in=>ex_mw, ea_in=>ex_ea, alu_res_in=>alu_result, bus_a_in=>ex_bus_a, bus_b_in=>ex_bus_b, reg_wr_en=>rf_wr_en, reg_wr_addr=>rf_wr_addr, reg_wr_data=>rf_wr_data, mem_wr_en=>mem_wr_en, mem_wr_addr=>mem_wr_addr, mem_wr_data=>mem_wr_data);
    u_dec: decoder_3to8 port map(seld=>rf_wr_addr, en=>rf_wr_en, y=>dec_out);

    obs_pc <= pc_cur; obs_mux4_out <= mux4_out_s; obs_muxi_out <= muxi_out_s; obs_mux2_out <= ar_s; obs_muxa_out <= muxa_out_s; obs_muxb_out <= muxb_out_s; obs_ar <= ar_s; obs_alu_result <= alu_result; obs_mem_out <= dmem_rd_data; obs_rf_wr_en <= rf_wr_en; obs_rf_wr_addr <= rf_wr_addr; obs_rf_wr_data <= rf_wr_data; obs_psw_z <= psw_z; obs_psw_s <= psw_s; obs_psw_v <= psw_v; obs_psw_c <= psw_c; obs_branch_taken <= branch_taken; obs_op_if <= instr_if(31 downto 26); obs_op_id <= instr_id(31 downto 26); obs_op_ear <= ear_instr(31 downto 26); obs_op_fo <= fo_opcode_r; obs_op_ex <= ex_opcode; obs_r1 <= r1; obs_r2 <= r2; obs_r3 <= r3; obs_r4 <= r4; obs_r5 <= r5; obs_r6 <= r6; obs_r7 <= r7;

end architecture structural;