----------------------------------------------------------------------------------
-- Namn:        cpu
-- Filnamn:     cpu.vhd
-- Testbench:   *ingen*
--
-- Insignaler:
--      clk     - klocksignal, all uppdatering av register sker vid stigande flank
--      n_rst   - synkron resetsignal, aktiv låg
--      INPUT   - insignalen JA synkroniserad i IO-blocket
--  
-- Utsignaler:
--      A        - adress till nästa instruktion
--      OUTPUT   - data som ska skrivs till signalen JB
--      OutEna   - laddsignal för utsignalsregistret i IO blocket
--      pc_debug - nuvarande adress, används för att visa adressen på 
--                 Nexys4 display
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;

entity cpu is
    port(
        clk, n_rst : in std_logic;
        I : in std_logic_vector(12 downto 0);
        INPUT : in std_logic_vector(7 downto 0);
        A : out std_logic_vector(5 downto 0);
        OUTPUT : out std_logic_vector(7 downto 0);
        OutEna : out std_logic;
        pc_debug : out std_logic_vector(5 downto 0)
    );
    
end entity;

architecture structural of cpu is
    signal Z : std_logic;
    signal K : std_logic_vector(9 downto 0);
    
begin
OutEna <= K(8);

addr: entity adressvaljare port map(
    clk => clk,
    n_rst => n_rst,
    DATA => I(5 downto 0),
    AddrSrc => K(3 downto 2), 
    StackOp => K(1 downto 0),
    pc_debug => pc_debug,
    A => A
);

ber: entity berakningsenhet port map (
    clk => clk,
    n_rst => n_rst,
    DATA => I(7 downto 0),
    DEST => I(8),
    Z => Z,
    INPUT => INPUT,
    RegEna => K(9),
    ALUOp => K(6 downto 4),
    ALUSrc => K(7),
    OUTPUT => OUTPUT
);

ins: entity instruktionsavkodare port map(
    OPCODE => I(12 downto 9),
    Z => Z,
    StackOp(1 downto 0) => K(1 downto 0),
    AddrSrc(1 downto 0) => K(3 downto 2),
    ALUOp(2 downto 0) => K(6 downto 4),
    ALUSrc => K(7),
    OutEna => K(8),
    RegEna => K(9)
);

end architecture;