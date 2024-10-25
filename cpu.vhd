library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
    generic
    (
        N: natural := 32;
        N_OP: natural := 4;
        N_ADDR_IMEM: natural := 8;
        MEM_DEPTH: natural := 2**N_ADDR_IMEM;
        MEM_FILE: string := "imem.txt";
        N_BIT_ADDR: natural := 5
    );
    port
    (
        clk: in std_logic
    );
end CPU;

architecture rtl of CPU is
    signal instr: std_logic_vector((N-1) downto 0);
    signal load: std_logic;
    signal we: std_logic;
    signal aluOp: std_logic_vector((N_OP-1) downto 0);

    signal pc_out: std_logic_vector((N-1) downto 0);

    signal BusA: std_logic_vector((N-1) downto 0);
    signal BusB: std_logic_vector((N-1) downto 0);
    signal BusW: std_logic_vector((N-1) downto 0) := (others => '0');

    alias funct7: std_logic_vector(6 downto 0) is instr(31 downto 25);
    alias rs2 : std_logic_vector(4 downto 0) is instr(24 downto 20);
    alias rs1 : std_logic_vector(4 downto 0) is instr(19 downto 15);
    alias funct3: std_logic_vector(2 downto 0) is instr(14 downto 12);
    alias rd : std_logic_vector(4 downto 0) is instr(11 downto 7);
    alias opcode : std_logic_vector(6 downto 0) is instr(6 downto 0);

    -- Debug
    signal instr_rs1: natural range 0 to (2**N_BIT_ADDR - 1);
    signal instr_rs2: natural range 0 to (2**N_BIT_ADDR - 1);
    signal instr_rd: natural range 0 to (2**N_BIT_ADDR - 1);

    function logic2integer(v: std_logic_vector) return integer is
    begin
        if Is_X(v) then -- to_integer does it by itself but throws a waring
            return 0;
        else
            return to_integer(unsigned(v));
        end if;
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

    component imem
        generic 
	    (
	    	MEM_WIDTH: natural := N;
            ADDR_WIDTH: natural := N_ADDR_IMEM;
            MEM_DEPTH: natural := MEM_DEPTH;
            MEM_FILE: string := MEM_FILE
	    );
	    port 
	    (
	    	addr	: in natural range 0 to MEM_DEPTH - 1;
	    	q		: out std_logic_vector((MEM_WIDTH - 1) downto 0)
	    );
    end component;

    component register_bench
        generic 
	    (
	    	DATA_WIDTH : natural := N;
	    	ADDR_WIDTH : natural := N_BIT_ADDR
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
            ADDR_SIZE: natural := N_BIT_ADDR;
            N_OP: natural := N_OP;
            VOID31: std_logic_vector((N-2) downto 0) := (others => '0')
        );
        port
        (
            opA: in std_logic_vector((N-1) downto 0);
            opB: in std_logic_vector((N-1) downto 0);
            aluOp: in std_logic_vector((N_OP-1) downto 0);
            res: out std_logic_vector((N-1) downto 0)
        );
    end component;
begin

    -- Debug
    instr_rs1 <= logic2integer(rs1);
    instr_rs2 <= logic2integer(rs2);
    instr_rd <= logic2integer(rd);

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
    
    imem1: imem
        generic map
        (
            MEM_WIDTH => N,
            ADDR_WIDTH => N_ADDR_IMEM,
            MEM_DEPTH => MEM_DEPTH,
            MEM_FILE => MEM_FILE
        )
        port map
        (
            addr => logic2integer(pc_out),
            q => instr
        );
    
    reg: register_bench
        generic map
        (
            DATA_WIDTH => N,
            ADDR_WIDTH => N_BIT_ADDR
        )
        port map
        (
            clk => clk,
            RW => logic2integer(rd),
            RA => logic2integer(rs1),
            RB => logic2integer(rs2),
            BusA => BusA,
            BusB => BusB,
            BusW => BusW,
            we => we
        );
    alu1: ALU
        generic map
        (
            N => N,
            ADDR_SIZE => N_BIT_ADDR,
            N_OP => N_OP,
            VOID31 => (others => '0')
        )
        port map
        (
            opA => BusA,
            opB => BusB,
            aluOp => aluOp,
            res => BusW
        );
end rtl;