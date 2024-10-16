library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pc is
end entity tb_pc;

architecture behav of tb_pc is

	component program_counter
	generic 
	(
		N : natural := 3
	);
	
	port
	(
		clk		: in std_logic;
		data_in	: in std_logic_vector((N-1) downto 0);
		data_out	: out std_logic_vector((N-1) downto 0);
		we		: in std_logic := '1'
	);
	end component;
	
	signal clk_t		: std_logic := '0';
	signal data_in_t	: std_logic_vector((3-1) downto 0);
	signal data_out_t	: std_logic_vector((3-1) downto 0);
	signal we_t : std_logic := '1';

begin

	pc: program_counter
	generic map
	(
		N => 3
	)
	
	port map
	(
		clk => clk_t,
		data_in => data_in_t,
		data_out => data_out_t,
		we => we_t
	);
	
	we_t <= '1', '0' after 6 ns, '1' after 30 ns;
	clk_t <= not clk_t after 5 ns;
	
	data_in_t <= "101", "010" after 10 ns;
	

end behav;