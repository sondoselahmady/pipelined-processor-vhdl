library ieee; use ieee.std_logic_1164.all;
entity if_id is
    port(clk,rst:in std_logic;
         instr_in,pc_in:in std_logic_vector(31 downto 0);
         instr_out,pc_out:out std_logic_vector(31 downto 0));
end entity;
architecture rtl of if_id is
begin
    process(clk,rst) begin
        if rst='1' then instr_out<=(others=>'0'); pc_out<=(others=>'0');
        elsif rising_edge(clk) then instr_out<=instr_in; pc_out<=pc_in; end if;
    end process;
end architecture;
