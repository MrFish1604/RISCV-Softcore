library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    generic
    (
        N: natural := 32;
        N_OP: natural := 4;
        REG_SIZE: natural := 5
    );
end CPU;

architecture rtl of CPU is
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
	    	data_out: out std_logic_vector((N-1) downto 0);
	    	we		: in std_logic := '1'
	    );
    end component;

    component single_port_rom_async
        generic 
	    (
	    	DATA_WIDTH : natural := N;
	    	ADDR_WIDTH : natural := N
	    );
	    port 
	    (
	    	addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
	    	q		: out std_logic_vector((DATA_WIDTH -1) downto 0)
	    );
    end component;

    component register_bench
        generic 
	    (
	    	DATA_WIDTH : natural := N;
	    	ADDR_WIDTH : natural := REG_SIZE
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
	    	we		: in std_logic
	    );
    end component;

    component ALU
        generic
        (
            N: natural := N;
            ADDR_SIZE: natural := REG_SIZE;
            N_OP: natural := N_OP;
            VOID31: std_logic_vector((N-2) downto 0) := std_logic_vector(to_unsigned(0, N-1))
        );
        port
        (
            opA: in std_logic_vector((N-1) downto 0);
            opB: in std_logic_vector((N-1) downto 0);
            aluOp: in std_logic_vector((N_OP-1) downto 0);
            res: out std_logic_vector((N-1) downto 0)
        );
    end component;

    signal load: std_logic;
    signal din: std_logic_vector((N-1) downto 0);
    signal dout: std_logic_vector((N-1) downto 0);
    signal instr: std_logic_vector((N-1) downto 0);
    signal we: std_logic := '1';
    signal BusW: std_logic_vector((N-1) downto 0);
    signal BusA: std_logic_vector((N-1) downto 0);
    signal BusB: std_logic_vector((N-1) downto 0);
    signal aluOp: std_logic_vector((N_OP-1) downto 0);
    
    signal mem_addr: natural range 0 to (2**N - 1);
    signal rs1_addr: natural range 0 to (2**REG_SIZE - 1);
    signal rs2_addr: natural range 0 to (2**REG_SIZE - 1);
    signal rd_addr: natural range 0 to (2**REG_SIZE - 1);

    signal clk: std_logic := '0';

    alias funct7: std_logic_vector(6 downto 0) is instr(31 downto 25);
    alias rs2 : std_logic_vector(4 downto 0) is instr(24 downto 20);
    alias rs1 : std_logic_vector(4 downto 0) is instr(19 downto 15);
    alias funct3: std_logic_vector(2 downto 0) is instr(14 downto 12);
    alias rd : std_logic_vector(4 downto 0) is instr(11 downto 7);
    alias opcode : std_logic_vector(6 downto 0) is instr(6 downto 0);
begin
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
    PC: program_counter_auto
        generic map
        (
            N => N
        )
        port map
        (
            clk => clk,
            data_in => din,
            data_out => dout,
            we => '1'
        );
    IMEM: single_port_rom_async
        generic map
        (
            DATA_WIDTH => N,
            ADDR_WIDTH => N
        )
        port map
        (
            addr => mem_addr,
            q => instr
        );
    REG: register_bench
        generic map
        (
            DATA_WIDTH => N,
            ADDR_WIDTH => REG_SIZE
        )
        port map
        (
            clk => clk,
            RW => rd_addr,
            RA => rs1_addr,
            RB => rs2_addr,
            BusA => BusA,
            BusB => BusB,
            BusW => BusW,
            we => we
        );
    
    ALU1: ALU
        generic map
        (
            N => N,
            ADDR_SIZE => REG_SIZE,
            N_OP => N_OP
        )
        port map
        (
            opA => BusA,
            opB => BusB,
            aluOp => aluOp,
            res => BusW
        );
    
    clk <= not clk after 10 ns;
    
    mem_addr <= to_integer(unsigned(dout));
    rs1_addr <= to_integer(unsigned(rs1));
    rs2_addr <= to_integer(unsigned(rs2));
    rd_addr <= to_integer(unsigned(rd));
end rtl;