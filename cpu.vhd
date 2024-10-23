library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    generic
    (
        N: natural := 32;
        N_OP: natural := 4;
        N_ADDR: natural := 8
    );
end CPU;

architecture rtl of CPU is
    signal clk: std_logic := '0';
    signal instr: std_logic_vector((N-1) downto 0);
    signal load: std_logic;
    signal we: std_logic;
    signal aluOp: std_logic_vector((N_OP-1) downto 0);

    signal pc_out: std_logic_vector((N-1) downto 0);

    signal funct3: std_logic_vector(2 downto 0);

    function conv_integer(v: std_logic_vector) return integer is
    begin
        return to_integer(unsigned(v));
    end function;

    component controleur
        generic
        (
            N: natural := N;
            N_OP: natural := N_OP
        );
        port
        (
            instr: in std_logic_vector((N-1) downto 0);
            load: out std_logic;
            we: out std_logic;
            aluOp: out std_logic_vector((N_OP-1) downto 0)
        );
    end component;

    component program_counter_auto
        generic 
	    (
	    	N: natural := N
	    );
	    port 
	    (
	    	clk		: in std_logic;
	    	data_in	: in std_logic_vector((N-1) downto 0);
	    	data_out	: out std_logic_vector((N-1) downto 0);
	    	we		: in std_logic
	    );
    end component;

    component single_port_rom_async
        generic 
	    (
	    	DATA_WIDTH : natural := N;
	    	ADDR_WIDTH : natural := N_ADDR
	    );
	    port 
	    (
	    	addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
	    	q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	    );
    end component;
begin
    clk <= not clk after 10 ns;
    funct3 <= instr(14 downto 12);

    ctrl: controleur
        generic map
        (
            N => N,
            N_OP => N_OP
        )
        port map
        (
            instr => instr,
            load => load,
            we => we,
            aluOp => aluOp
        );
    
    pc: program_counter_auto
        generic map
        (
            N => N
        )
        port map
        (
            clk => clk,
            data_in => std_logic_vector(to_unsigned(0, N)),
            data_out => pc_out,
            we => '1'
        );
    
    imem: single_port_rom_async
        generic map
        (
            DATA_WIDTH => N,
            ADDR_WIDTH => N_ADDR
        )
        port map
        (
            addr => conv_integer(pc_out),
            q => instr
        );
end rtl;