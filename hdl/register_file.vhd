-- =========================================================
-- register_file.vhd
--   8 x 32-bit GPRs. R0 always reads 0, write blocked.
-- =========================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        wr_en   : in  std_logic;
        wr_addr : in  std_logic_vector(2  downto 0);
        wr_data : in  std_logic_vector(31 downto 0);
        reg_out : out std_logic_vector(255 downto 0)
    );
end entity register_file;

architecture rtl of register_file is
    type reg_t is array(0 to 7) of std_logic_vector(31 downto 0);
    signal regs : reg_t;
begin
    process(clk, rst)
    begin
        if rst = '1' then
            regs(0) <= (others=>'0');
            regs(1) <= x"00000001";
            regs(2) <= x"00000002";
            regs(3) <= (others=>'0');
            regs(4) <= (others=>'0');
            regs(5) <= (others=>'0');
            regs(6) <= x"000000FF";
            regs(7) <= x"00000007";
        elsif rising_edge(clk) then
            if wr_en='1' and wr_addr/="000" then
                regs(to_integer(unsigned(wr_addr))) <= wr_data;
            end if;
        end if;
    end process;

    gen: for i in 0 to 7 generate
        reg_out(i*32+31 downto i*32) <=
            (others=>'0') when i=0 else regs(i);
    end generate;
end architecture rtl;
