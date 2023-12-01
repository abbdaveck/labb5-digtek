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
    
begin

end architecture;