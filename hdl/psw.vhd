-- =========================================================
-- psw.vhd : Program Status Word (V S C Z flags)
-- =========================================================
library ieee;
use ieee.std_logic_1164.all;

entity psw is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        v_in,s_in,c_in,z_in   : in  std_logic;
        v_flag,s_flag,c_flag,z_flag : out std_logic
    );
end entity psw;

architecture rtl of psw is
begin
    process(clk,rst)
    begin
        if rst='1' then
            v_flag<='0'; s_flag<='0'; c_flag<='0'; z_flag<='0';
        elsif rising_edge(clk) then
            v_flag<=v_in; s_flag<=s_in; c_flag<=c_in; z_flag<=z_in;
        end if;
    end process;
end architecture rtl;
