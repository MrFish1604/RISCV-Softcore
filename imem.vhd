library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity IMEM is
    generic
    (
        MEM_WIDTH: natural := 32;
        ADDR_WIDTH: natural := 8;
        MEM_DEPTH: natural := 2**ADDR_WIDTH;
        MEM_FILE: string := "imem.txt"
    );
    port
    (
        addr: in natural range 0 to MEM_DEPTH - 1 :=0 ;
        q: out std_logic_vector((MEM_WIDTH-1) downto 0)
    );
end IMEM;

architecture rtl of IMEM is
    type memory_t is array(0 to MEM_DEPTH - 1) of std_logic_vector((MEM_WIDTH-1) downto 0);

    impure function load_mem_from_file(filename: string) return memory_t is
        file f: text;
        variable mem: memory_t;
        variable l: line;
        variable a: natural:=0;
    begin
        file_open(f, filename, READ_MODE);
        mem := (others => (others => '0'));
        while not endfile(f) loop
            if a >= MEM_DEPTH then
                report "load_mem_from_file: Memory initialization file too large" severity ERROR;
            end if;
            readline(f, l);
            read(l, mem(a));
            a := a + 1;
        end loop;
        report "load_mem_from_file: Loaded " & integer'image(a) & " words from file '" & filename & "'. Remaining " & integer'image(MEM_DEPTH-a) & " free words." severity NOTE;
        return mem;
    end function;
    
    signal rom: memory_t := load_mem_from_file(MEM_FILE);
begin
    q <= rom(addr);
end rtl;