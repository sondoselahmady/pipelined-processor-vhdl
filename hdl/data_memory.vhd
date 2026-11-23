library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity data_memory is
    port (
        clk     : in  std_logic;
        rd_addr : in  std_logic_vector(17 downto 0);
        rd_en   : in  std_logic;
        rd_data : out std_logic_vector(31 downto 0);
        wr_addr : in  std_logic_vector(17 downto 0);
        wr_data : in  std_logic_vector(31 downto 0);
        wr_en   : in  std_logic
    );
end entity data_memory;

architecture rtl of data_memory is
    type mem_t is array(0 to 262143) of std_logic_vector(31 downto 0);
    
    impure function init_ram return mem_t is
        file text_file : text open read_mode is "dmem.txt";
        variable text_line : line;
        variable ram_content : mem_t := (others => (others => '0'));
        variable addr : integer;
        variable data : std_logic_vector(31 downto 0);
        variable space : character;
    begin
        while not endfile(text_file) loop
            readline(text_file, text_line);
            read(text_line, addr);
            read(text_line, space);
            hread(text_line, data);
            ram_content(addr) := data;
        end loop;
        return ram_content;
    end function;

    signal mem : mem_t := init_ram;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if wr_en = '1' then
                mem(to_integer(unsigned(wr_addr))) <= wr_data;
            end if;
        end if;
    end process;
    rd_data <= mem(to_integer(unsigned(rd_addr))) when rd_en = '1' else (others => '0');
end architecture rtl;