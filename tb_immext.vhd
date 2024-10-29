library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity tb_immext is
    generic
    (
        N: natural := 32;
        IMM_SIZE: natural := 12;
        SHAMT_SIZE: natural := 5;
        TYPE_SIZE: natural := 1
    );
end tb_immext;

architecture behav of tb_immext is
    type instr_set_t is array(0 to 9) of std_logic_vector((N-1) downto 0);
    type expected_t is array(0 to 19) of integer;
    component imm_ext
        generic
        (
            N: natural := N;
            IMM_SIZE: natural := IMM_SIZE;
            SHAMT_SIZE: natural := SHAMT_SIZE;
            TYPE_SIZE: natural := TYPE_SIZE
        );
        port
        (
            instr: in std_logic_vector((N-1) downto 0);
            instType: in std_logic_vector((TYPE_SIZE-1) downto 0);
            immExt: out std_logic_vector((N-1) downto 0)
        );
    end component;
    signal instr_set: instr_set_t := (
        "11101100000110011111000010101010", -- -319
        "10111001100001000101100101010000", -- -1128
        "11001001100010111101110101011010", -- -872
        "10001010010000000000111010100000", -- -1884
        "10100111011010111101010000001000", -- -1418
        "00111111000100101001001100011011", -- 1009
        "11011000011011000100101110111101", -- -634
        "10010010011000010000000010110001", -- -1754
        "00101010111111000110111111100110",-- 687
        "01000011100101110011001001110100" -- 1081
    );
    signal instr: std_logic_vector((N-1) downto 0); --:= instr_set(0);
    signal ext: std_logic_vector((N-1) downto 0);
    signal expected: expected_t  := (
        -319, -1128, -872, -1884, -1418, 1009, -634, -1754, 687, 1081, -- instType = 0
        1, 24, 24, 4, 22, 17, 6, 6, 15, 25 -- instType = 1
    );
    signal instType: std_logic_vector((TYPE_SIZE-1) downto 0);
    signal ok: boolean := false;
    signal failed_test: natural := 0;
begin
    uut: imm_ext
        generic map
        (
            N => N,
            IMM_SIZE => IMM_SIZE,
            SHAMT_SIZE => SHAMT_SIZE,
            TYPE_SIZE => TYPE_SIZE
        )
        port map
        (
            instr => instr,
            instType => instType,
            immExt => ext
        );

    process
    variable l: line;
    begin
        for i in 0 to 19 loop
            instType <= "0" when i < 10 else "1";
            instr <= instr_set(i mod 10);
            wait for 10 ns;
            ok <= to_integer(signed(ext)) = expected(i);
            wait for 10 ns;
            write(l, to_string(instr) & " " & to_string(expected(i)) & " " & to_string(to_integer(signed(ext))) & " "); --& to_string(ok));
            writeline(output, l);
            write(l, to_string(ext) & " ok is " & to_string(ok));
            writeline(output, l);
            if not ok then
                report "Test failed on the " & to_string(i) & "th instruction." severity ERROR;
                failed_test <= failed_test + 1;
            end if;
            write(l, String'(" "));
            writeline(output, l);
        end loop;
        wait for 10 ns;
        if failed_test = 0 then
            report "All test passed successfully" severity NOTE;
        else
            report to_string(failed_test) & " tests failed." severity ERROR;
        end if;
        wait;
    end process;

end behav;
