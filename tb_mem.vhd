library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb_mem is
end entity tb_mem;

architecture behav of tb_mem is

    component single_port_rom_async 

    generic 
    (
        DATA_WIDTH : natural := 8;
        ADDR_WIDTH : natural := 8
    );

    port 
    (
        addr    : in natural range 0 to 2**ADDR_WIDTH - 1;
        q        : out std_logic_vector((DATA_WIDTH -1) downto 0)
    );

    end component;

    signal addr_t : natural range 0 to 255;
    signal q_t : std_logic_vector (7 downto 0);
    signal clk_t : std_logic:='0';

begin

    rom_1: single_port_rom_async

    generic map
    (
        DATA_WIDTH => 8,
        ADDR_WIDTH => 8
    )

    port map
    (
        addr    => addr_t,
        q        => q_t
    );

clk_t <= not clk_t after 5 ns;

addr_t <= 0, 1 after 20 ns, 2 after 40 ns, 3 after 60 ns, 4 after 80 ns, 5 after 100 ns, 6 after 120 ns, 7 after 140 ns, 8 after 160 ns, 9 after 180 ns, 10 after 200 ns, 11 after 220 ns;



end behav;