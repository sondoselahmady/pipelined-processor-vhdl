-- =========================================================
-- alu.vhd : 32-bit ALU (VHDL-93)
-- =========================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
    port (
        opr    : in  std_logic_vector(3  downto 0);
        a      : in  std_logic_vector(31 downto 0);
        b      : in  std_logic_vector(31 downto 0);
        result : out std_logic_vector(31 downto 0);
        z_flag : out std_logic;
        s_flag : out std_logic;
        v_flag : out std_logic;
        c_flag : out std_logic
    );
end entity alu;

architecture rtl of alu is
begin
    process(opr, a, b)
        variable ua,ub : unsigned(31 downto 0);
        variable sa,sb : signed(31 downto 0);
        variable u33a,u33b,u33r : unsigned(32 downto 0);
        variable s33a,s33b,s33r : signed(32 downto 0);
        variable vr : std_logic_vector(31 downto 0);
        variable vc,vv : std_logic;
    begin
        ua:=unsigned(a); ub:=unsigned(b);
        sa:=signed(a);   sb:=signed(b);
        u33a:='0'&ua; u33b:='0'&ub;
        s33a:=resize(sa,33); s33b:=resize(sb,33);
        vr:=(others=>'0'); vc:='0'; vv:='0';
        case opr is
            when "0000" => vr:=a;                                         -- NOP
            when "0001" =>                                                 -- ADD
                u33r:=u33a+u33b; vr:=std_logic_vector(u33r(31 downto 0));
                vc:=u33r(32);
                s33r:=s33a+s33b; vv:=s33r(32) xor s33r(31);
            when "0010" =>                                                 -- SUB
                u33r:=u33a-u33b; vr:=std_logic_vector(u33r(31 downto 0));
                vc:=u33r(32);
                s33r:=s33a-s33b; vv:=s33r(32) xor s33r(31);
            when "0011" =>                                                 -- MUL
                vr:=std_logic_vector(resize(ua*ub,32));
            when "0100" =>                                                 -- DIV
                if ub=0 then vr:=(others=>'1');
                else vr:=std_logic_vector(ua/ub); end if;
            when "0101" => vr:=a and b;                                   -- AND
            when "0110" => vr:=a or  b;                                   -- OR
            when "0111" => vr:=a xor b;                                   -- XOR
            when "1000" => vr:=not a;                                     -- NOT
            when "1001" =>                                                 -- SLT
                if sa<sb then vr:=std_logic_vector(to_unsigned(1,32));
                else vr:=(others=>'0'); end if;
            when "1010" =>                                                 -- SLL
                vr:=std_logic_vector(shift_left(ua,to_integer(ub(4 downto 0))));
            when "1011" =>                                                 -- SRL
                vr:=std_logic_vector(shift_right(ua,to_integer(ub(4 downto 0))));
            when "1100" =>                                                 -- SRA
                vr:=std_logic_vector(shift_right(sa,to_integer(ub(4 downto 0))));
            when others => vr:=(others=>'0');
        end case;
        result <= vr;
        if unsigned(vr)=0 then z_flag<='1'; else z_flag<='0'; end if;
        s_flag <= vr(31);
        c_flag <= vc;
        v_flag <= vv;
    end process;
end architecture rtl;
