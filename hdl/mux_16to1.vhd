-- =========================================================
-- mux_16to1.vhd  m0-m7=R0-R7  m8=mem_out  m9=immediate
-- =========================================================
library ieee;
use ieee.std_logic_1164.all;
entity mux_16to1 is
    generic(WIDTH:integer:=32);
    port(sel:in std_logic_vector(3 downto 0);
         m0,m1,m2,m3,m4,m5,m6,m7:in std_logic_vector(WIDTH-1 downto 0);
         m8,m9,m10,m11,m12,m13,m14,m15:in std_logic_vector(WIDTH-1 downto 0);
         y:out std_logic_vector(WIDTH-1 downto 0));
end entity;
architecture rtl of mux_16to1 is
begin
    process(sel,m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15)
    begin
        case sel is
            when "0000"=>y<=m0;  when "0001"=>y<=m1;
            when "0010"=>y<=m2;  when "0011"=>y<=m3;
            when "0100"=>y<=m4;  when "0101"=>y<=m5;
            when "0110"=>y<=m6;  when "0111"=>y<=m7;
            when "1000"=>y<=m8;  when "1001"=>y<=m9;
            when "1010"=>y<=m10; when "1011"=>y<=m11;
            when "1100"=>y<=m12; when "1101"=>y<=m13;
            when "1110"=>y<=m14; when others=>y<=m15;
        end case;
    end process;
end architecture;
