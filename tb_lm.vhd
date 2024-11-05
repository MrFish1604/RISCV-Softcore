library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_lm is
    generic(
        N: integer := 32;
        M: integer := 3
    );
end tb_lm;

architecture behav of tb_lm is
    component lm
        generic(
            N: natural := N;
            M: natural := M
        );
        port(
            input: in std_logic_vector((N-1) downto 0);
            width: in std_logic_vector((M-1) downto 0);
            lm_out: out std_logic_vector((N-1) downto 0)
        );
    end component;
    signal input: std_logic_vector((N-1) downto 0) := (31 downto 12 => '1', others => '0');
    signal width: std_logic_vector((M-1) downto 0) := "000";
    signal lm_out: std_logic_vector((N-1) downto 0);
begin
    uut: lm port map(
        input => input,
        width => width,
        lm_out => lm_out
    );

    process
        variable l: line;
    begin
        for i in 1 to 21 loop
            wait for 10 ns;
            write(l, "width  " & to_string(width));
            writeline(output, l);
            -- write(l, "input  " & to_str_split(input));
            for j in 7 downto 0 loop
                write(l, to_string(input(j*4+3 downto j*4)) & " ");
            end loop;
            writeline(output, l);
            -- write(l, "output " & to_str_split(lm_out));
            for j in 7 downto 0 loop
                write(l, to_string(lm_out(j*4+3 downto j*4)) & " ");
            end loop;
            writeline(output, l);
            writeline(output, l);
            input <= not input(31) & std_logic_vector(to_unsigned(100234421*i, N-1));
            width <= "001" when i<10 else "010" when i<15 else "100" when i<20 else "101";
        end loop;
        wait;
    end process;
end behav;
