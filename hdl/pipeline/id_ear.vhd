library ieee; use ieee.std_logic_1164.all;
entity id_ear is
    port(clk,rst:in std_logic;
         sela_in,selb_in:in std_logic_vector(3 downto 0);
         seld_in:in std_logic_vector(2 downto 0);
         seli_in,opr_in:in std_logic_vector(3 downto 0);
         mr_in,mw_in,ms_in,mi_in,br_in,jt_in:in std_logic;
         instr_in,pc_in:in std_logic_vector(31 downto 0);
         sela_out,selb_out:out std_logic_vector(3 downto 0);
         seld_out:out std_logic_vector(2 downto 0);
         seli_out,opr_out:out std_logic_vector(3 downto 0);
         mr_out,mw_out,ms_out,mi_out,br_out,jt_out:out std_logic;
         instr_out,pc_out:out std_logic_vector(31 downto 0));
end entity;
architecture rtl of id_ear is
begin
    process(clk,rst) begin
        if rst='1' then
            sela_out<=(others=>'0'); selb_out<=(others=>'0');
            seld_out<=(others=>'0'); seli_out<=(others=>'0');
            opr_out<=(others=>'0');
            mr_out<='0'; mw_out<='0'; ms_out<='0';
            mi_out<='0'; br_out<='0'; jt_out<='0';
            instr_out<=(others=>'0'); pc_out<=(others=>'0');
        elsif rising_edge(clk) then
            sela_out<=sela_in; selb_out<=selb_in;
            seld_out<=seld_in; seli_out<=seli_in; opr_out<=opr_in;
            mr_out<=mr_in; mw_out<=mw_in; ms_out<=ms_in;
            mi_out<=mi_in; br_out<=br_in; jt_out<=jt_in;
            instr_out<=instr_in; pc_out<=pc_in;
        end if;
    end process;
end architecture;
