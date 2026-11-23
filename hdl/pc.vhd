-- =========================================================
-- pc.vhd : 32-bit Program Counter
-- =========================================================
library ieee;
use ieee.std_logic_1164.all;

entity pc is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        pc_in  : in  std_logic_vector(31 downto 0);
        pc_out : out std_logic_vector(31 downto 0)
    );
end entity pc;

architecture rtl of pc is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            pc_out <= (others => '0');
        elsif rising_edge(clk) then
            pc_out <= pc_in;
        end if;
    end process;
end architecture rtl;
