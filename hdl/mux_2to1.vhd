-- =========================================================
-- mux_2to1.vhd
-- =========================================================
library ieee;
use ieee.std_logic_1164.all;
entity mux_2to1 is
    generic(WIDTH:integer:=32);
    port(sel:in std_logic;
         m0,m1:in std_logic_vector(WIDTH-1 downto 0);
         y:out std_logic_vector(WIDTH-1 downto 0));
end entity;
architecture rtl of mux_2to1 is
begin
    y <= m1 when sel='1' else m0;
end architecture;
