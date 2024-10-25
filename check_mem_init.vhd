library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use std.textio.all;

entity check_mem_init is
    generic
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 8
    );
end entity check_mem_init;

architecture test of check_mem_init is
    component single_port_rom_async
    generic 
	(
		DATA_WIDTH : natural := DATA_WIDTH;
		ADDR_WIDTH : natural := ADDR_WIDTH
	);

	port 
	(
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);
    end component;
    signal data: std_logic_vector((DATA_WIDTH -1) downto 0);
    signal addr: natural range 0 to 2**ADDR_WIDTH - 1;
begin
    rom_1: single_port_rom_async
    generic map
    (
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map
    (
        addr    => addr,
        q => data
    );

    process 
        variable l: line;
    begin
        for i in 0 to 15 loop --(2**ADDR_WIDTH -1) loop
            wait for 1 ns;
            addr <= i;
            write(l, String'("Address "));
            if addr < 10 then
                write(l, String'(" "));
            end if;
            write(l, to_string(addr));
            write(l, String'(": "));
            write(l, to_string(data));
            writeline(output, l);
        end loop;
        wait;
    end process;
end test ; -- test