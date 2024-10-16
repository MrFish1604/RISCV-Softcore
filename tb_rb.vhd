library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_rb is
	generic
	(
		DATA_W: natural := 32;
		ADDR_W: natural := 5
	);
end entity tb_rb;

architecture behav of tb_rb is

	component register_bench
	generic
	(
		DATA_WIDTH : natural := DATA_W;
		ADDR_WIDTH : natural := ADDR_W
	);
	port
	(
		clk		: in std_logic;
		RW	: in natural range 0 to 2**ADDR_WIDTH - 1;
		RA	: in natural range 0 to 2**ADDR_WIDTH - 1;
		RB	: in natural range 0 to 2**ADDR_WIDTH - 1;
		BusA	: out std_logic_vector((DATA_WIDTH-1) downto 0);
		BusB	: out std_logic_vector((DATA_WIDTH-1) downto 0);
		BusW	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1'
	);
	end component;
	
	signal clk_t: std_logic := '0';
	signal RW_t	: natural range 0 to 2**ADDR_W - 1;
	signal RA_t	: natural range 0 to 2**ADDR_W - 1;
	signal RB_t	: natural range 0 to 2**ADDR_W - 1;
	signal BusA_t	: std_logic_vector((DATA_W-1) downto 0);
	signal BusB_t	: std_logic_vector((DATA_W-1) downto 0);
	signal BusW_t	: std_logic_vector((DATA_W-1) downto 0);
	signal we_t	:  std_logic := '0';

begin

	rb: register_bench
	generic map
	(
		DATA_WIDTH => DATA_W,
		ADDR_WIDTH => ADDR_W
	)
	port map
	(
		clk => clk_t,
		RW => RW_t,
		RA => RA_t,
		RB => RB_t,
		BusA => BusA_t,
		BusB => BusB_t,
		BusW => BusW_t,
		we => we_t
	);
	

clk_t <= not clk_t after 5 ns;

RW_t <=	0,
			2 after 6 ns,
			4 after 12 ns,
			6 after 18 ns,
			8 after 24 ns,
			10 after 30 ns,
			12 after 36 ns,
			14 after 42 ns,
			16 after 48 ns,
			18 after 54 ns,
			20 after 60 ns,
			22 after 66 ns,
			24 after 72 ns,
			26 after 78 ns,
			28 after 84 ns,
			30 after 90 ns;

BusW_t <= "10011001100110011001100110011001";
we_t <= '1', '0' after 60 ns;

RA_t <=	0,
			2 after 6 ns,
			4 after 12 ns,
			6 after 18 ns,
			8 after 24 ns,
			10 after 30 ns,
			12 after 36 ns,
			14 after 42 ns,
			16 after 48 ns,
			18 after 54 ns,
			20 after 60 ns,
			22 after 66 ns,
			24 after 72 ns,
			26 after 78 ns,
			28 after 84 ns,
			30 after 90 ns;

RB_t <=	1,
			3 after 6 ns,
			5 after 12 ns,
			7 after 18 ns,
			9 after 24 ns,
			0 after 30 ns,
			13 after 36 ns,
			15 after 42 ns,
			17 after 48 ns,
			19 after 54 ns,
			21 after 60 ns,
			23 after 66 ns,
			25 after 72 ns,
			27 after 78 ns,
			29 after 84 ns,
			31 after 90 ns;

end behav;