library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_alu is
    generic
    (
        N_t: natural := 32;
        N_OP_t: natural := 4
    );
end entity tb_alu;

architecture behav of tb_alu is

    component ALU
    generic
    (
        N: natural := N_t;
        N_OP: natural := N_OP_t
    );
    port
    (
        opA: in std_logic_vector((N-1) downto 0);
        opB: in std_logic_vector((N-1) downto 0);
        aluOp: in std_logic_vector((N_OP-1) downto 0);
        res: out std_logic_vector((N-1) downto 0)
    );
    end component;

    signal opA_t: std_logic_vector((N_t-1) downto 0) := std_logic_vector(to_signed(0, N_t));
    signal opB_t: std_logic_vector((N_t-1) downto 0) := std_logic_vector(to_signed(0, N_t));
    signal aluOp_t: std_logic_vector((N_OP_t-1) downto 0);
    signal res_t: std_logic_vector((N_t-1) downto 0);

    signal incr: natural := 0;
begin
    uut: ALU
    generic map
    (
        N => N_t,
        N_OP => N_OP_t
    )
    port map
    (
        opA => opA_t,
        opB => opB_t,
        aluOp => aluOp_t,
        res => res_t
    );

    process begin
    for i in 0 to 2**N_OP_t-1 loop
        opA_t <= std_logic_vector(to_signed(incr, N_t));
        opB_t <= std_logic_vector(to_signed(incr+1, N_t));
        aluOp_t <= std_logic_vector(to_unsigned(i, N_OP_t));
        incr <= incr + 1;
        wait for 10 ns;
    end loop;
    end process;
end behav;

        