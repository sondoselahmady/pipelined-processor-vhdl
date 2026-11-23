-- =========================================================
-- ear_fo.vhd : EAR / FO pipeline register
-- =========================================================
library ieee;
use ieee.std_logic_1164.all;

entity ear_fo is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        sela_in    : in  std_logic_vector(3  downto 0);
        selb_in    : in  std_logic_vector(3  downto 0);
        seld_in    : in  std_logic_vector(2  downto 0);
        opr_in     : in  std_logic_vector(3  downto 0);
        mr_in      : in  std_logic;
        mw_in      : in  std_logic;
        ea_in      : in  std_logic_vector(17 downto 0);
        imm_in     : in  std_logic_vector(31 downto 0);
        offset_in  : in  std_logic_vector(17 downto 0);
        pc_in      : in  std_logic_vector(31 downto 0);
        br_in      : in  std_logic;
        jt_in      : in  std_logic;

        sela_out   : out std_logic_vector(3  downto 0);
        selb_out   : out std_logic_vector(3  downto 0);
        seld_out   : out std_logic_vector(2  downto 0);
        opr_out    : out std_logic_vector(3  downto 0);
        mr_out     : out std_logic;
        mw_out     : out std_logic;
        ea_out     : out std_logic_vector(17 downto 0);
        imm_out    : out std_logic_vector(31 downto 0);
        offset_out : out std_logic_vector(17 downto 0);
        pc_out     : out std_logic_vector(31 downto 0);
        br_out     : out std_logic;
        jt_out     : out std_logic
    );
end entity ear_fo;

architecture rtl of ear_fo is
begin
    process(clk, rst)
    begin
        if rst = '1' then
            sela_out   <= (others=>'0'); selb_out   <= (others=>'0');
            seld_out   <= (others=>'0'); opr_out    <= (others=>'0');
            mr_out     <= '0';          mw_out     <= '0';
            ea_out     <= (others=>'0'); imm_out    <= (others=>'0');
            offset_out <= (others=>'0'); pc_out     <= (others=>'0');
            br_out     <= '0';          jt_out     <= '0';
        elsif rising_edge(clk) then
            sela_out   <= sela_in;  selb_out   <= selb_in;
            seld_out   <= seld_in;  opr_out    <= opr_in;
            mr_out     <= mr_in;    mw_out     <= mw_in;
            ea_out     <= ea_in;    imm_out    <= imm_in;
            offset_out <= offset_in; pc_out    <= pc_in;
            br_out     <= br_in;    jt_out     <= jt_in;
        end if;
    end process;
end architecture rtl;
