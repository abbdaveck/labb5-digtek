--
-- Den här filen innehåller definitioner för signalerna StackOp, AddrSrc och OPCODE.
-- Efter att en rad avkomenterats och fått rätt värde kan konstanten användas i alla filer
-- där följande finns med:
--
--      library work;
--      use work.cpu_pkg.all;
--
-- Användning av konstanterna gör koden lättare att läsa och felsöka.
-- Testbäddarna kommer också att använda dessa konstanter så det är viktigt att de fylls i korrekt!

library ieee;
use ieee.std_logic_1164.all;

package cpu_pkg is

    -- Fyll i rätt värde för för signalen StackOp som styr stackens operation.
    -- Glöm inte att avkommentera raderna!
    constant STACK_OP_POP          : std_logic_vector(1 downto 0) := "10";
    constant STACK_OP_PUSH         : std_logic_vector(1 downto 0) := "01";
    constant STACK_OP_HOLD         : std_logic_vector(1 downto 0) := "00";
    
     -- Fyll i rätt värde för för signalen AddrSrc som bestämmer varifrån nästa adress ska tas.
    constant ADDR_PC_PLUS_ONE   : std_logic_vector(1 downto 0) := "00";
    constant ADDR_TOS           : std_logic_vector(1 downto 0) := "10";
    constant ADDR_DATA          : std_logic_vector(1 downto 0) := "01";
    
     -- Fyll i rätt värde för för signalen OPCODE som avgör vilken instruktion det är.
    constant OPCODE_CALL             : std_logic_vector(3 downto 0) := "0000";
    constant OPCODE_RET              : std_logic_vector(3 downto 0) := "0001";
    constant OPCODE_BZ               : std_logic_vector(3 downto 0) := "0010";
    constant OPCODE_B                : std_logic_vector(3 downto 0) := "0011";
    constant OPCODE_ADD              : std_logic_vector(3 downto 0) := "0100";
    constant OPCODE_SUB              : std_logic_vector(3 downto 0) := "0101";
    constant OPCODE_LD               : std_logic_vector(3 downto 0) := "0110";
    constant OPCODE_IN               : std_logic_vector(3 downto 0) := "0111";
    constant OPCODE_OUT              : std_logic_vector(3 downto 0) := "1000";
    constant OPCODE_AND              : std_logic_vector(3 downto 0) := "1001";
    
end package;

