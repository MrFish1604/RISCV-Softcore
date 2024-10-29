library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux21 is
    generic(
        N: integer := 32
    );
    port(
        a: in std_logic_vector((N-1) downto 0);
        b: in std_logic_vector((N-1) downto 0);
        output: out std_logic_vector((N-1) downto 0);
        sel: in std_logic
    );
end mux21;


architecture behav of mux21 is
begin
    output <= a when sel = '0' else b;
end behav;
