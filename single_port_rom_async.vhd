-- Quartus Prime VHDL Template
-- Single-Port ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_rom_async is

	generic 
	(
		DATA_WIDTH : natural := 8;
		ADDR_WIDTH : natural := 8
	);

	port 
	(
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	);

end entity;

architecture rtl of single_port_rom_async is

	-- Build a 2-D array type for the ROM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	function init_rom
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));
	begin
		tmp := (others => (
			6 downto 0 => "0110011",
			19 downto 15 => "00010",
			24 downto 20 => "00011",
			11 downto 7 => "11111",
			others => '0'
		));
		for addr_pos in 0 to 7 loop 
			-- Initialize each address with the address itself
			tmp(addr_pos)(14 downto 12) := std_logic_vector(to_unsigned(addr_pos, 3));
		end loop;
		tmp(8)(14 downto 12) := "000";
		tmp(8)(30) := '1';
		tmp(9)(14 downto 12) := "101";
		tmp(9)(30) := '1';
		return tmp;
	end init_rom;	 

	-- Declare the ROM signal and specify a default value.	Quartus Prime
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal rom : memory_t := init_rom;

begin
	q <= rom(addr);

end rtl;
