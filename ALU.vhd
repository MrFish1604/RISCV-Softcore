library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    generic
    (
        N: natural := 32;
        ADDR_SIZE: natural := 5;
        N_OP: natural := 4;
        VOID31: std_logic_vector((30) downto 0) := std_logic_vector(to_unsigned(0, 31))
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
    function bool2logic(b: boolean) return std_logic is
    begin
        if b then
            return '1';
        else
            return '0';
        end if;
    end;
begin
    res <= std_logic_vector(signed(opA) + signed(opB)) when aluOp="0000" -- add
        else std_logic_vector(signed(opA) - signed(opB)) when aluOp="1000" -- sub
        else std_logic_vector(shift_left(unsigned(opA), to_integer(unsigned(opB((ADDR_SIZE-1) downto 0))))) when aluOp3="001" -- sll
        else VOID31 & bool2logic(signed(opA) < signed(opB)) when aluOp3="010" -- slt
        else VOID31 & bool2logic(unsigned(opA) < unsigned(opB)) when aluOp3="011" -- sltu
        else opA xor opB when aluOp3="100" -- xor
        else std_logic_vector(shift_right(unsigned(opA), to_integer(unsigned(opB((ADDR_SIZE-1) downto 0))))) when aluOp="0101" -- srl
        else std_logic_vector(shift_right(signed(opA), to_integer(unsigned(opB((ADDR_SIZE-1) downto 0))))) when aluOp="1101" -- sra
        else opA or opB when aluOp3="110" -- or
        else opA and opB when aluOp3="111" -- and
        else std_logic_vector(to_unsigned(0, N)); -- undefined
end rtl;