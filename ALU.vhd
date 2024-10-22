library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    generic
    (
        N: natural := 32;
        ADDR_SIZE: natural := 5;
        
        N_OP: natural := 4
    );
    port
    (
        opA: in std_logic_vector((N-1) downto 0);
        opB: in std_logic_vector((N-1) downto 0);
        aluOp: in std_logic_vector((N_OP-1) downto 0);
        res: out std_logic_vector((N-1) downto 0)
    );
    alias aluOp3: std_logic_vector((N_OP-2) downto 0) is aluOp((N_OP-2) downto 0);
end ALU;


architecture rtl of ALU is
begin
    res <= std_logic_vector(signed(opA) + signed(opB)) when aluOp="0000"
        else std_logic_vector(signed(opA) - signed(opB)) when aluOp="1000"
        else std_logic_vector(shift_left(unsigned(opA), to_integer(unsigned(opB((ADDR_SIZE-1) downto 0))))) when aluOp3="001"
        else std_logic_vector(to_unsigned(0, N));
end rtl;