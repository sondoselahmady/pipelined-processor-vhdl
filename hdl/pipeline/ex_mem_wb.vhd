library ieee;
use ieee.std_logic_1164.all;

entity ex_mem_wb is
    port (
        clk, rst     : in  std_logic;
        seld_in      : in  std_logic_vector(2  downto 0);
        mw_in        : in  std_logic;
        ea_in        : in  std_logic_vector(17 downto 0);
        alu_res_in   : in  std_logic_vector(31 downto 0);
        bus_a_in     : in  std_logic_vector(31 downto 0);
        bus_b_in     : in  std_logic_vector(31 downto 0);

        reg_wr_en    : out std_logic;
        reg_wr_addr  : out std_logic_vector(2  downto 0);
        reg_wr_data  : out std_logic_vector(31 downto 0);

        mem_wr_en    : out std_logic;
        mem_wr_addr  : out std_logic_vector(17 downto 0);
        mem_wr_data  : out std_logic_vector(31 downto 0)
    );
end entity ex_mem_wb;

architecture rtl of ex_mem_wb is
    signal seld_r  : std_logic_vector(2  downto 0) := (others=>'0');
    signal mw_r    : std_logic := '0';
    signal ea_r    : std_logic_vector(17 downto 0) := (others=>'0');
    signal alu_r   : std_logic_vector(31 downto 0) := (others=>'0');
    signal busa_r  : std_logic_vector(31 downto 0) := (others=>'0');
begin
    process(clk, rst)
    begin
        if rst = '1' then
            seld_r <= (others=>'0'); mw_r <= '0'; ea_r <= (others=>'0');
            alu_r <= (others=>'0'); busa_r <= (others=>'0'); 
        elsif rising_edge(clk) then
            seld_r <= seld_in; mw_r <= mw_in; ea_r <= ea_in;
            alu_r <= alu_res_in; busa_r <= bus_a_in;
        end if;
    end process;
    
    reg_wr_en   <= '1' when (seld_r /= "000" and mw_r = '0') else '0';
    reg_wr_addr <= seld_r;
    reg_wr_data <= alu_r;

    mem_wr_en   <= mw_r;
    mem_wr_addr <= ea_r;
    mem_wr_data <= busa_r;
end architecture rtl;