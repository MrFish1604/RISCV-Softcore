library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pc is
	generic
	(
		N: natural := 32
	);
end entity tb_pc;

architecture behav of tb_pc is

	component program_counter_auto
	generic 
	(
		N : natural := N
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
	signal data_in_t	: std_logic_vector((N-1) downto 0);
	signal data_out_t	: std_logic_vector((N-1) downto 0);
	signal we_t : std_logic := '1';

begin

	pc: program_counter_auto
	generic map
	(
		N => N
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
	
	data_in_t <= std_logic_vector(to_unsigned(3, N)), std_logic_vector(to_unsigned(2, N)) after 10 ns;
	

end behav;