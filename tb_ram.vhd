library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity tb_ram is
end entity tb_ram;

architecture behav of tb_ram is

    component single_port_ram_async 

    generic 
    (
        DATA_WIDTH : natural := 32;
        ADDR_WIDTH : natural := 8
    );

    port 
    (
      clk		: in std_logic;
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1';
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
    );

    end component;

    signal addr_t : natural range 0 to 255;
    signal q_t : std_logic_vector (31 downto 0);
    signal clk_t : std_logic:='0';
	 signal data_t : std_logic_vector (31 downto 0);
	 signal we_t : std_logic:='0';

begin

    ram_1: single_port_ram_async

    generic map
    (
        DATA_WIDTH => 32,
        ADDR_WIDTH => 8
    )

    port map
    (
		clk	=> clk_t,
		addr    => addr_t,
		q        => q_t,
		data => data_t,
		we => we_t
    );

clk_t <= not clk_t after 5 ns;

we_t <= '0', '1' after 150 ns, '0' after 310 ns;

data_t <= q_t when(addr_t = 7);

addr_t <=	0,
				1 after 20 ns,
				2 after 40 ns,
				3 after 60 ns,
				4 after 80 ns,
				5 after 100 ns,
				6 after 120 ns,
				7 after 140 ns,
				0 after 160 ns,
				1 after 180 ns,
				2 after 200 ns,
				3 after 220 ns,
				4 after 240 ns,
				5 after 260 ns,
				6 after 280 ns,
				7 after 300 ns,
				0 after 320 ns,
				1 after 340 ns,
				2 after 360 ns,
				3 after 380 ns,
				4 after 400 ns,
				5 after 420 ns,
				6 after 440 ns,
				7 after 460 ns;



end behav;