library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ctrl is
	generic
	(
		N_t : natural := 32;
		N_OP_t : natural := 4
	);
end entity tb_ctrl;

architecture behav of tb_ctrl is

	component controleur
	generic
	(
		N : natural := N_t;
		N_OP : natural := N_OP_t
	);

	port
	(
		instr: in std_logic_vector((N-1) downto 0);
        load: out std_logic:='0';
        we: out std_logic:='1';
        aluOp: out std_logic_vector((N_OP-1) downto 0);
        RI_sel: out std_logic;
        loadAcc: out std_logic;
        wr_size: out natural range 0 to N_OP := 0;
        imm_type: out std_logic
	);
	end component;

	signal instr_t: std_logic_vector((N_t-1) downto 0) := (others => '0');
    signal load_t: std_logic:='0';
    signal we_t: std_logic:='1';
    signal aluOp_t: std_logic_vector((N_OP_t-1) downto 0);

	alias funct7: std_logic_vector(6 downto 0) is instr_t(31 downto 25);
	alias funct3: std_logic_vector(2 downto 0) is instr_t(14 downto 12);

begin
	uut: controleur
	generic map
	(
		N => N_t,
		N_OP => N_OP_t
	)
	port map
	(
		instr => instr_t,
		load => load_t,
		we => we_t,
		aluOp => aluOp_t
	);

	process begin
	for i in 0 to 7 loop
		funct3 <= std_logic_vector(to_unsigned(i, 3));
		wait for 10 ns;
	end loop;
	wait for 10 ns;
	funct3 <= std_logic_vector(to_unsigned(0, 3));
	funct7 <= "0100000";
	wait for 10 ns;
	funct3 <= std_logic_vector(to_unsigned(1, 3));
	wait for 10 ns;
	funct7 <= "0000000";
	wait;
	end process;

end behav;
