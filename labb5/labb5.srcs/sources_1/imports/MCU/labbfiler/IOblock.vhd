----------------------------------------------------------------------------------
-- Namn:        IOblock
-- Filnamn:     IOblock.vhd
-- Testbench:   *ingen*
--
-- Beskrivning:
--      Kretsen läser in värdet från JA vid varje klockflank. Värdet synkroniseras
--      i ett register vars värde läsas från utsignalen INPUT. 
--
--      Insignalen OUTPUT är ansluten till ett register som styrs med signalen 
--      OutEna. Då OutEna är hög laddas registret med OUTPUT vid nästa klockflank.
--      Registrets värde läses från JB.
--
-- Insignaler:
--      clk     - klocksignal, all uppdatering av register sker vid stigande flank
--      n_rst   - synkron resetsignal, aktiv låg
--      OutEna  - laddsignal till utsignalsregistret
--      JA      - data in till Nexys4, ansluts til kontakten JA på Nexys4
--      OUTPUT  - data som ska skrivs till JB
--
-- Utsignaler:
--      JB      - data ut från Nexys4, ansluts till kontakten JB på Nexys4
--      INPUT   - JA synkroniserad
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity IOblock is
    port(
        clk : in std_logic;
        n_rst : in std_logic;
        OutEna : in std_logic;
        JA : in std_logic_vector(7 downto 0);
        OUTPUT : in std_logic_vector(7 downto 0);
        JB : out std_logic_vector(7 downto 0);
        INPUT : out std_logic_vector(7 downto 0)
    );
end entity;

architecture structural of IOblock is

begin
    
    input_buffer_i: entity REG8 port map(
        D => JA,
        Q => INPUT,
        CLK => clk,
        CLR => n_rst,
        ENA => '1'
    );
    
    output_buffer_i: entity REG8 port map(
        D => OUTPUT,
        Q => JB,
        CLK => clk,
        CLR => n_rst,
        ENA => OutEna
    );

end architecture;