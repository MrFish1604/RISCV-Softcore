library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity IMEM is
    generic
    (
        MEM_WIDTH: natural := 8;
        WORD_BYTES: natural := 4;
        ADDR_WIDTH: natural := 8;
        MEM_DEPTH: natural := 2**ADDR_WIDTH;
        MEM_FILE: string := "imem.txt"
    );
    port
    (
        addr: in natural range 0 to MEM_DEPTH - 1 :=0 ;
        q: out std_logic_vector((MEM_WIDTH*WORD_BYTES-1) downto 0)
    );
end IMEM;

architecture rtl of IMEM is
    type memory_t is array(0 to MEM_DEPTH - 1) of std_logic_vector((MEM_WIDTH-1) downto 0);
    type bytes_t is array(WORD_BYTES-1 downto 0) of std_logic_vector((MEM_WIDTH-1) downto 0);

    function hexchar2slv(c: character) return std_logic_vector is
        variable slv: std_logic_vector(3 downto 0);
        variable a: integer;
    begin
        a := character'pos(c);
        a := a - character'pos('a') + 10 when a>=character'pos('a')
            else a - character'pos('A') + 10 when a>=character'pos('A')
            else a - character'pos('0');
        slv := std_logic_vector(to_unsigned(a, 4));
        return slv;
    end function;

    impure function hex2slv(hex:string) return bytes_t is
        variable rtn: bytes_t;
        variable a: integer;
    begin
        for i in WORD_BYTES-1 downto 0 loop
            rtn(i) := hexchar2slv(hex(i*2+2)) & hexchar2slv(hex(i*2+1));
        end loop;
        return rtn;
    end function;

    impure function load_mem_from_file(filename: string) return memory_t is
        file f: text;
        variable mem: memory_t;
        variable word: std_logic_vector((MEM_WIDTH*WORD_BYTES-1) downto 0);
        variable l: line;
        variable a: natural:=0;
        variable s: string(8 downto 1);
    begin
        file_open(f, filename, READ_MODE);
        mem := (others => (others => 'U'));
        while not endfile(f) loop
            if a >= MEM_DEPTH then
                report "load_mem_from_file: Memory initialization file too large" severity ERROR;
            end if;
            readline(f, l);
            if l'length = 32 then
                read(l, word);
                for i in WORD_BYTES-1 downto 0 loop
                    mem(a + WORD_BYTES-1 - i) := word(MEM_WIDTH*(i+1)-1 downto i*MEM_WIDTH);
                end loop;
            elsif l'length = 8 then
                read(l, s);
                for i in WORD_BYTES-1 downto 0 loop
                    mem(a + WORD_BYTES-1 - i) := hex2slv(s)(i);
                end loop;
            elsif l'length /= 0 then -- ignore empty lines
                mem(a to a+3) := (others => (others => 'X'));
                report "Can't load instruction at line " & integer'image(a) & " from file '" & filename & "'. Line length is " & integer'image(l'length) & " instead of 32." severity ERROR;
            end if;
            a := a + WORD_BYTES;
        end loop;
        report "load_mem_from_file: Loaded " & integer'image(a) & " bytes from file '" & filename & "'. Remaining " & integer'image(MEM_DEPTH-a) & " free bytes." severity NOTE;
        return mem;
    end function;

    signal rom: memory_t := load_mem_from_file(MEM_FILE);
begin
    Q_GEN: for i in WORD_BYTES-1 downto 0 generate
        q(MEM_WIDTH*(i+1)-1 downto i*MEM_WIDTH) <= rom(addr + WORD_BYTES - 1 - i);
    end generate;
end rtl;
