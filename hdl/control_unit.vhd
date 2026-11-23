library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
    port (
        instr : in  std_logic_vector(31 downto 0);
        SELA  : out std_logic_vector(3 downto 0);
        SELB  : out std_logic_vector(3 downto 0);
        SELD  : out std_logic_vector(2 downto 0);
        SELI  : out std_logic_vector(3 downto 0);
        OPR   : out std_logic_vector(3 downto 0);
        MR,MW,MS,MI,BR,JT : out std_logic
    );
end entity control_unit;

architecture rtl of control_unit is
    constant SEL_MEM : std_logic_vector(3 downto 0) := "1000";
    constant SEL_IMM : std_logic_vector(3 downto 0) := "1001";
    
    constant OP_NOP : std_logic_vector(5 downto 0) := "000000";
    constant OP_ADD : std_logic_vector(5 downto 0) := "000001";
    constant OP_AND : std_logic_vector(5 downto 0) := "000010";
    constant OP_LW  : std_logic_vector(5 downto 0) := "000011";
    constant OP_BEQ : std_logic_vector(5 downto 0) := "000100";
    constant OP_SUB : std_logic_vector(5 downto 0) := "000101";
    constant OP_OR  : std_logic_vector(5 downto 0) := "000110";
    constant OP_SW  : std_logic_vector(5 downto 0) := "000111";
    constant OP_MUL : std_logic_vector(5 downto 0) := "001000";
    constant OP_XOR : std_logic_vector(5 downto 0) := "001001";
    constant OP_BNE : std_logic_vector(5 downto 0) := "001010";
    constant OP_SLL : std_logic_vector(5 downto 0) := "001011";
    constant OP_DIV : std_logic_vector(5 downto 0) := "001101";
    constant OP_NOT : std_logic_vector(5 downto 0) := "001110";
    constant OP_J   : std_logic_vector(5 downto 0) := "010000";
    constant OP_CMP : std_logic_vector(5 downto 0) := "010001";

    constant ALU_NOP : std_logic_vector(3 downto 0) := "0000";
    constant ALU_ADD : std_logic_vector(3 downto 0) := "0001";
    constant ALU_SUB : std_logic_vector(3 downto 0) := "0010";
    constant ALU_MUL : std_logic_vector(3 downto 0) := "0011";
    constant ALU_DIV : std_logic_vector(3 downto 0) := "0100";
    constant ALU_AND : std_logic_vector(3 downto 0) := "0101";
    constant ALU_OR  : std_logic_vector(3 downto 0) := "0110";
    constant ALU_XOR : std_logic_vector(3 downto 0) := "0111";
    constant ALU_NOT : std_logic_vector(3 downto 0) := "1000";
    constant ALU_SLL : std_logic_vector(3 downto 0) := "1010";
begin
    process(instr)
        variable op   : std_logic_vector(5 downto 0);
        variable mode : std_logic_vector(1 downto 0);
        variable dest : std_logic_vector(2 downto 0);
        variable src1 : std_logic_vector(2 downto 0);
        variable src2r: std_logic_vector(2 downto 0);
        
        variable va,vb,vi,vo : std_logic_vector(3 downto 0);
        variable vd          : std_logic_vector(2 downto 0);
        variable vmr,vmw,vms,vmi,vbr,vjt : std_logic;
    begin
        op    := instr(31 downto 26);
        mode  := instr(25 downto 24);
        dest  := instr(23 downto 21);
        src1  := instr(20 downto 18);
        src2r := instr(2 downto 0);

        -- EA & Mode Resolution
        case mode is
            when "00" => -- Immediate 
                vms:='0'; vmi:='0'; vi:=SEL_IMM; vb:=SEL_IMM; vmr:='0';
            when "01" => -- Direct
                vms:='0'; vmi:='0'; vi:=SEL_IMM; vb:=SEL_MEM; vmr:='1';
            when "10" => -- Reg Indirect
                vms:='1'; vmi:='0'; vi:="0"&src2r; vb:=SEL_MEM; vmr:='1';
            when "11" => -- Mem Indirect
                vms:='1'; vmi:='1'; vi:=SEL_MEM; vb:=SEL_MEM; vmr:='1';
            when others => null;
        end case;

        -- Opcode Overrides
        va := "0" & src1;
        vd := dest;
        vmw := '0'; vbr := '0'; vjt := '0';

        case op is
            when OP_ADD => vo := ALU_ADD;
            when OP_SUB => vo := ALU_SUB;
            when OP_MUL => vo := ALU_MUL;
            when OP_DIV => vo := ALU_DIV;
            when OP_AND => vo := ALU_AND;
            when OP_OR  => vo := ALU_OR;
            when OP_XOR => vo := ALU_XOR;
            when OP_SLL => vo := ALU_SLL;
            when OP_NOT => vo := ALU_NOT;
            when OP_LW  => vo := ALU_NOP; va := vb; 
            when OP_SW  => 
                vmw := '1'; vmr := '0'; vd := "000"; vo := ALU_NOP; va := "0"&dest;
            when OP_BEQ => vo := ALU_SUB; vbr := '1'; vd := "000"; vmr := '0'; vb := "0"&dest;
            when OP_BNE => vo := ALU_SUB; vbr := '1'; vd := "000"; vmr := '0'; vb := "0"&dest;
            when OP_J   => vo := ALU_NOP; vjt := '1'; vd := "000"; vmr := '0';
            when OP_CMP => vo := ALU_SUB; vd := "000"; vmr := '0'; vb := "0"&src2r;
            when others => vo := ALU_NOP; vd := "000"; vmr := '0';
        end case;

        SELA<=va; SELB<=vb; SELD<=vd; SELI<=vi; OPR<=vo;
        MR<=vmr; MW<=vmw; MS<=vms; MI<=vmi; BR<=vbr; JT<=vjt;
    end process;
end architecture rtl;