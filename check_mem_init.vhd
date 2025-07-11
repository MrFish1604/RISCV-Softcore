library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use std.textio.all;

entity check_mem_init is
    generic
    (
        MEM_WIDTH: natural := 8;
        ADDR_WIDTH: natural := 8;
        WORD_BYTES: natural := 4;
        WORD_SIZE: natural := MEM_WIDTH*WORD_BYTES;
        MEM_DEPTH: natural := 2**ADDR_WIDTH;
        MEM_FILE: string := "imem.txt"
    );
end entity check_mem_init;

architecture test of check_mem_init is
    component imem
        generic
        (
            MEM_WIDTH: natural := MEM_WIDTH;
            ADDR_WIDTH: natural := ADDR_WIDTH;
            WORD_BYTES: natural := 4;
            MEM_DEPTH: natural := MEM_DEPTH;
            MEM_FILE: string := MEM_FILE
        );
        port
        (
            addr: in natural range 0 to MEM_DEPTH - 1 :=0 ;
            q: out std_logic_vector((WORD_SIZE-1) downto 0)
        );
    end component;

    signal data: std_logic_vector((WORD_SIZE -1) downto 0);
    signal addr: natural range 0 to MEM_DEPTH - 1;
begin
    rom_1: imem
        generic map
        (
            MEM_WIDTH => MEM_WIDTH,
            WORD_BYTES => WORD_BYTES,
            ADDR_WIDTH => ADDR_WIDTH,
            MEM_DEPTH => MEM_DEPTH,
            MEM_FILE => MEM_FILE
        )
        port map
        (
            addr => addr,
            q => data
        );

    process
        variable l: line;
        variable i: natural;
    begin
        while i<2**ADDR_WIDTH loop --(2**ADDR_WIDTH -1) loop
            wait for 10 ns;
            addr <= i;
            write(l, String'("Address "));
            if addr < 10 then
                write(l, String'(" "));
            end if;
            write(l, to_string(addr));
            write(l, String'(": "));
            -- write(l, to_string(data));
            for j in 7 downto 0 loop
                write(l, to_string(data(j*4+3 downto j*4)) & " ");
            end loop;
            writeline(output, l);
            i := i + WORD_BYTES;
        end loop;
        wait;
    end process;
end test ; -- test
