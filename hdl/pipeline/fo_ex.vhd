library ieee;
use ieee.std_logic_1164.all;

entity fo_ex is
    port (
        clk, rst   : in  std_logic;
        seld_in    : in  std_logic_vector(2  downto 0);
        opr_in     : in  std_logic_vector(3  downto 0);
        mr_in, mw_in : in std_logic;
        ea_in      : in  std_logic_vector(17 downto 0);
        bus_a_in, bus_b_in, pc_in : in std_logic_vector(31 downto 0);
        br_in, jt_in : in std_logic;
        offset_in  : in  std_logic_vector(17 downto 0);
        imm_in     : in  std_logic_vector(31 downto 0);

        seld_out   : out std_logic_vector(2  downto 0);
        opr_out    : out std_logic_vector(3  downto 0);
        mr_out, mw_out : out std_logic;
        ea_out     : out std_logic_vector(17 downto 0);
        bus_a_out, bus_b_out, pc_out : out std_logic_vector(31 downto 0);
        br_out, jt_out : out std_logic;
        offset_out : out std_logic_vector(17 downto 0);
        imm_out    : out std_logic_vector(31 downto 0)
    );
end entity fo_ex;

architecture rtl of fo_ex is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            seld_out <= (others=>'0'); opr_out <= (others=>'0');
            mr_out <= '0'; mw_out <= '0';
            ea_out <= (others=>'0');
            bus_a_out <= (others=>'0'); bus_b_out <= (others=>'0'); pc_out <= (others=>'0');
            br_out <= '0'; jt_out <= '0';
            offset_out <= (others=>'0'); imm_out <= (others=>'0');
        elsif rising_edge(clk) then
            seld_out <= seld_in; opr_out <= opr_in;
            mr_out <= mr_in; mw_out <= mw_in;
            ea_out <= ea_in;
            bus_a_out <= bus_a_in; bus_b_out <= bus_b_in; pc_out <= pc_in;
            br_out <= br_in; jt_out <= jt_in;
            offset_out <= offset_in; imm_out <= imm_in;
        end if;
    end process;
end architecture rtl;