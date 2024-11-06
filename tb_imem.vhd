library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_imem is
    generic(
        N: natural := 32;
        MEM_WIDTH: natural := 8
    );
end tb_imem;

architecture behav of tb_imem is
    component imem is
        port(
            addr: in natural range 0 to 2**8 - 1 :=0 ;
            q: out std_logic_vector((N-1) downto 0);
            data: std_logic_vector((MEM_WIDTH-1) downto 0);
            we: std_logic
        );
    end component;
    signal addr: natural range 0 to 2**8 - 1 := 0;
    signal q: std_logic_vector((N-1) downto 0);
    signal data: std_logic_vector((MEM_WIDTH-1) downto 0);
    signal we: std_logic := '0';
begin
    uut: imem port map(
        addr => addr,
        q => q,
        data => data,
        we => we
    );

    process
        variable l: line;
    begin
        for a in 0 to 10 loop
            wait for 5 ns;
            addr <= a;
            data <= std_logic_vector(to_unsigned(3*(a+1), MEM_WIDTH));
            wait for 5 ns;
            for j in 7 downto 6 loop
                write(l, to_string(q(j*4+3 downto j*4)) & " ");
            end loop;
            writeline(output, l);
            we <= '1';
            wait for 5 ns;
            we <= '0';
            for j in 7 downto 6 loop
                write(l, to_string(q(j*4+3 downto j*4)) & " ");
            end loop;
            writeline(output, l);
            writeline(output, l);
        end loop;
        wait;
    end process;

end behav;
