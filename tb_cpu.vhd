library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cpu is
    generic
    (
        N: natural := 32;
        N_OP: natural := 4;
        N_ADDR_IMEM: natural := 8;
        N_BIT_ADDR: natural := 5
    );
end tb_cpu;

architecture behav of tb_cpu is
    signal clk: std_logic := '0';
    signal rst: std_logic := '0';
    component CPU
        generic
        (
            N: natural := N;
            N_OP: natural := N_OP;
            N_ADDR_IMEM: natural := N_ADDR_IMEM;
            N_BIT_ADDR: natural := N_BIT_ADDR
        );
        port
        (
            clk: in std_logic
        );
    end component;
begin
    clk <= not clk after 10 ns;

    uut: cpu
        generic map
        (
            N => N,
            N_OP => N_OP,
            N_ADDR_IMEM => N_ADDR_IMEM,
            N_BIT_ADDR => N_BIT_ADDR
        )
        port map
        (
            clk => clk
        );
end behav ;