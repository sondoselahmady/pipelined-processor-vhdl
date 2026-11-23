library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity instruction_memory is
    port (
        addr : in  std_logic_vector(7 downto 0);
        data : out std_logic_vector(31 downto 0)
    );
end entity instruction_memory;

architecture rtl of instruction_memory is
    type rom_t is array(0 to 255) of std_logic_vector(31 downto 0);
    
    impure function init_rom return rom_t is
        file text_file : text open read_mode is "imem.txt";
        variable text_line : line;
        variable rom_content : rom_t := (others => (others => '0'));
        variable i : integer := 0;
        variable temp : std_logic_vector(31 downto 0);
    begin
        while not endfile(text_file) loop
            readline(text_file, text_line);
            hread(text_line, temp);
            rom_content(i) := temp;
            i := i + 1;
        end loop;
        return rom_content;
    end function;

    constant rom : rom_t := init_rom;
begin
    data <= rom(to_integer(unsigned(addr)));
end architecture rtl;