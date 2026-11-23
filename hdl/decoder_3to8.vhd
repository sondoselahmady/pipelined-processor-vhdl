-- =========================================================
-- decoder_3to8.vhd  R0 write always blocked
-- =========================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity decoder_3to8 is
    port(seld:in std_logic_vector(2 downto 0);
         en:in std_logic;
         y:out std_logic_vector(7 downto 0));
end entity;
architecture rtl of decoder_3to8 is
begin
    process(seld,en)
        variable v:std_logic_vector(7 downto 0);
    begin
        v:=(others=>'0');
        if en='1' and seld/="000" then
            v(to_integer(unsigned(seld))):='1';
        end if;
        v(0):='0';
        y<=v;
    end process;
end architecture;
