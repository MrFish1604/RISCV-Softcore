library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imm_ext is
    generic
    (
        N: natural := 32;
        IMM_SIZE: natural := 12;
        SHAMT_SIZE: natural := 5;
        TYPE_SIZE: natural := 1
    );
    port
    (
        instr: in std_logic_vector((N-1) downto 0);
        instType: in std_logic_vector((TYPE_SIZE-1) downto 0);
        immExt: out std_logic_vector((N-1) downto 0)
    );
    alias imm: std_logic_vector((IMM_SIZE-1) downto 0) is instr(31 downto 20);
    alias shamt: std_logic_vector((SHAMT_SIZE-1) downto 0) is instr(24 downto 20);
    alias funct2: std_logic_vector(1 downto 0) is instr(13 downto 12);
end imm_ext;

architecture rtl of imm_ext is
begin
    immExt <= std_logic_vector(resize(unsigned(shamt), N)) when funct2="01"
        else std_logic_vector(resize(signed(imm), N));

end rtl;
