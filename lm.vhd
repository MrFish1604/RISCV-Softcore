library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lm is
    generic(
        N: natural := 32;
        M: natural := 3
    );
    port(
        input: in std_logic_vector((N-1) downto 0);
        width: in std_logic_vector((M-1) downto 0);
        lm_out: out std_logic_vector((N-1) downto 0)
    );
end lm;

architecture rtl of lm is
    signal w: natural;
begin
    w <= 4 when width(1)='1' else to_integer(unsigned(width(1 downto 0))) + 1;
    lm_out <= std_logic_vector(resize(unsigned(input((N-1) downto N-8*w)), N)) when width(2)='1'
        else std_logic_vector(resize(signed(input((N-1) downto N-8*w)), N));
end rtl;
