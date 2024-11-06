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
            data: std_logic_vector((N-1) downto 0);
            wr_size: in natural range 0 to 4 := 0
        );
    end component;
    signal addr: natural range 0 to 2**8 - 1 := 0;
    signal q: std_logic_vector((N-1) downto 0);
    signal data: std_logic_vector((N-1) downto 0);
    signal wr_size: natural range 0 to 4 := 0;
    signal w: natural;
begin
    uut: imem port map(
        addr => addr,
        q => q,
        data => data,
        wr_size => wr_size
    );

    process
        variable l: line;
    begin
        for a in 0 to 10 loop
            wait for 5 ns;
            addr <= a;
            data <= std_logic_vector(to_unsigned(567283*(a+1), N));
            wait for 5 ns;
            for j in 7 downto 0 loop
                write(l, to_string(data(j*4+3 downto j*4)) & " ");
            end loop;
            writeline(output, l);
            for j in 7 downto 0 loop
                write(l, to_string(q(j*4+3 downto j*4)) & " ");
            end loop;
            writeline(output, l);
            wr_size <= 1 when a < 3 else 2 when a < 8 else 4;
            wait for 5 ns;
            w <= wr_size;
            write(l, "wr_size: " & integer'image(wr_size));
            writeline(output, l);
            wr_size <= 0;
            wait for 5 ns;
            for j in 7 downto 0 loop
                write(l, to_string(q(j*4+3 downto j*4)) & " ");
            end loop;
            if q(31 downto 8*(4-w)) = data(8*(w-1)+7 downto 0) then
                report "OK" severity note;
            else
                report "ERROR   " & to_string(q(31 downto 8*(4-w))) & " /= " & to_string(data(8*(w-1)+7 downto 0)) severity note;
            end if;
            writeline(output, l);
            writeline(output, l);
        end loop;
        wait;
    end process;

end behav;
