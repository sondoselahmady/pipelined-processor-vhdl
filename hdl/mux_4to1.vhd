-- =========================================================
-- mux_4to1.vhd  sel={JT,BR_taken}
--   00->PC+1  01->PC+OFFSET  10->jump_addr 
-- =========================================================
library ieee;
use ieee.std_logic_1164.all;
entity mux_4to1 is
    generic(WIDTH:integer:=32);
    port(sel:in std_logic_vector(1 downto 0);
         m0,m1,m2,m3:in std_logic_vector(WIDTH-1 downto 0);
         y:out std_logic_vector(WIDTH-1 downto 0));
end entity;
architecture rtl of mux_4to1 is
begin
    process(sel,m0,m1,m2,m3)
    begin
        case sel is
            when "00" => y<=m0;
            when "01" => y<=m1;
            when "10" => y<=m2;
            when others => y<=m3;
        end case;
    end process;
end architecture;
