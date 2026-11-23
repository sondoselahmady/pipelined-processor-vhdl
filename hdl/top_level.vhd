-- =========================================================
-- top_level.vhd
-- =========================================================
library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port (
        clk          : in  std_logic;
        rst          : in  std_logic;

        pc_out       : out std_logic_vector(31 downto 0);
        mux4_out     : out std_logic_vector(31 downto 0);
        muxi_out     : out std_logic_vector(31 downto 0);
        mux2_out     : out std_logic_vector(17 downto 0);
        muxa_out     : out std_logic_vector(31 downto 0);
        muxb_out     : out std_logic_vector(31 downto 0);
        ar_out       : out std_logic_vector(17 downto 0);
        mem_out      : out std_logic_vector(31 downto 0);
        alu_out      : out std_logic_vector(31 downto 0);
        psw_z        : out std_logic;
        psw_s        : out std_logic;
        psw_v        : out std_logic;
        psw_c        : out std_logic;
        branch_taken : out std_logic;
        rf_wr_en     : out std_logic;
        rf_wr_addr   : out std_logic_vector(2  downto 0);
        rf_wr_data   : out std_logic_vector(31 downto 0);
        stage_if     : out std_logic_vector(5 downto 0);
        stage_id     : out std_logic_vector(5 downto 0);
        stage_ear    : out std_logic_vector(5 downto 0);
        stage_fo     : out std_logic_vector(5 downto 0);
        stage_ex     : out std_logic_vector(5 downto 0);
        r1           : out std_logic_vector(31 downto 0);
        r2           : out std_logic_vector(31 downto 0);
        r3           : out std_logic_vector(31 downto 0);
        r4           : out std_logic_vector(31 downto 0);
        r5           : out std_logic_vector(31 downto 0);
        r6           : out std_logic_vector(31 downto 0);
        r7           : out std_logic_vector(31 downto 0)
    );
end entity top_level;

architecture structural of top_level is

    component processor
        port (
            clk             : in  std_logic;
            rst             : in  std_logic;
            obs_pc          : out std_logic_vector(31 downto 0);
            obs_mux4_out    : out std_logic_vector(31 downto 0);
            obs_muxi_out    : out std_logic_vector(31 downto 0);
            obs_mux2_out    : out std_logic_vector(17 downto 0);
            obs_muxa_out    : out std_logic_vector(31 downto 0);
            obs_muxb_out    : out std_logic_vector(31 downto 0);
            obs_ar          : out std_logic_vector(17 downto 0);
            obs_alu_result  : out std_logic_vector(31 downto 0);
            obs_mem_out     : out std_logic_vector(31 downto 0);
            obs_rf_wr_en    : out std_logic;
            obs_rf_wr_addr  : out std_logic_vector(2  downto 0);
            obs_rf_wr_data  : out std_logic_vector(31 downto 0);
            obs_psw_z       : out std_logic;
            obs_psw_s       : out std_logic;
            obs_psw_v       : out std_logic;
            obs_psw_c       : out std_logic;
            obs_branch_taken: out std_logic;
            obs_op_if       : out std_logic_vector(5  downto 0);
            obs_op_id       : out std_logic_vector(5  downto 0);
            obs_op_ear      : out std_logic_vector(5  downto 0);
            obs_op_fo       : out std_logic_vector(5  downto 0);
            obs_op_ex       : out std_logic_vector(5  downto 0);
            obs_r1          : out std_logic_vector(31 downto 0);
            obs_r2          : out std_logic_vector(31 downto 0);
            obs_r3          : out std_logic_vector(31 downto 0);
            obs_r4          : out std_logic_vector(31 downto 0);
            obs_r5          : out std_logic_vector(31 downto 0);
            obs_r6          : out std_logic_vector(31 downto 0);
            obs_r7          : out std_logic_vector(31 downto 0)
        );
    end component;

begin

    u_proc : processor
        port map (
            clk             => clk,
            rst             => rst,
            obs_pc          => pc_out,
            obs_mux4_out    => mux4_out,
            obs_muxi_out    => muxi_out,
            obs_mux2_out    => mux2_out,
            obs_muxa_out    => muxa_out,
            obs_muxb_out    => muxb_out,
            obs_ar          => ar_out,
            obs_alu_result  => alu_out,
            obs_mem_out     => mem_out,
            obs_rf_wr_en    => rf_wr_en,
            obs_rf_wr_addr  => rf_wr_addr,
            obs_rf_wr_data  => rf_wr_data,
            obs_psw_z       => psw_z,
            obs_psw_s       => psw_s,
            obs_psw_v       => psw_v,
            obs_psw_c       => psw_c,
            obs_branch_taken=> branch_taken,
            obs_op_if       => stage_if,
            obs_op_id       => stage_id,
            obs_op_ear      => stage_ear,
            obs_op_fo       => stage_fo,
            obs_op_ex       => stage_ex,
            obs_r1          => r1,
            obs_r2          => r2,
            obs_r3          => r3,
            obs_r4          => r4,
            obs_r5          => r5,
            obs_r6          => r6,
            obs_r7          => r7
        );

end architecture structural;
