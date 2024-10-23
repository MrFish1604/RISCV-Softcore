library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter_auto is

	generic 
	(
		N: natural := 3
	);

	port 
	(
		clk		: in std_logic;
		data_in	: in std_logic_vector((N-1) downto 0);
		data_out	: out std_logic_vector((N-1) downto 0);
		we		: in std_logic := '1'
	);

end program_counter_auto;

architecture rtl of program_counter_auto is
    signal s: std_logic_vector((N-1) downto 0):=std_logic_vector(to_unsigned(0, N));
begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		if(we = '1') then
			s <= std_logic_vector(unsigned(s) + 1);
		end if;
	end if;
	end process;
    data_out <= s;
end rtl;
