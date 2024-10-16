library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_bench is

	generic 
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 5
	);

	port 
	(
		clk		: in std_logic;
		RW	: in natural range 0 to (2**ADDR_WIDTH - 1);
		RA	: in natural range 0 to (2**ADDR_WIDTH - 1);
		RB	: in natural range 0 to (2**ADDR_WIDTH - 1);
		BusA	: out std_logic_vector((DATA_WIDTH-1) downto 0);
		BusB	: out std_logic_vector((DATA_WIDTH-1) downto 0);
		BusW	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		we		: in std_logic := '1'
	);

end register_bench;

architecture rtl of register_bench is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	function init_rb
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin 
		tmp(0) := std_logic_vector(to_unsigned(0, DATA_WIDTH));
		for addr_pos in 1 to 2**ADDR_WIDTH - 1 loop 
			-- Initialize each address with the 31 - address itself
			tmp(addr_pos) := std_logic_vector(to_unsigned(31 - addr_pos, DATA_WIDTH));
		end loop;
		return tmp;
	end init_rb;	 

	signal regs : memory_t := init_rb;

begin

--	regs(0) <= std_logic_vector(to_unsigned(0, DATA_WIDTH));

	BusA <= regs(RA);
	BusB <= regs(RB);
	
	process(clk) begin
	if(rising_edge(clk)) then
		if(we = '1') then
			case RW is
				when 0 =>
					regs(0) <= std_logic_vector(to_unsigned(0, DATA_WIDTH));
				when others =>
					regs(RW) <= BusW;
			end case;
		end if;
	end if;
	end process;
end rtl;
