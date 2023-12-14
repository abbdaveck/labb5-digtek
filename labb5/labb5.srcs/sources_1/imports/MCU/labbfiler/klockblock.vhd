----------------------------------------------------------------------------------
-- Namn:        klockblock
-- Filnamn:     klockblock.vhd
-- Testbench:   *ingen*
--
-- Beskrivning:
--      Generar klocksignal till mikrokontrollern som kan vara 2 Hz eller
--      manuell, generard med en tryckknapp.
--
-- Insignaler:
--      clk_100MHz - 100 MHz klocka från Nexys4
--      n_rst      - synkron resetsignal, aktiv låg
--      clk_sel    - väljer manuell klocka eller 2 Hz klocka
--      clk_btn    - ansluts till tryckknapp för manuell klocka
--
-- Utsignaler:
--      clk_out - vald klocka
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity klockblock is
    port(
        clk_100MHz : in std_logic;
		n_rst : in std_logic;
        clk_sel : in std_logic;
        clk_btn : in std_logic;
        clk_out : out std_logic
    );
end entity;

architecture behaviour of klockblock is

    signal clk_div : std_logic;
    signal clk_btn_deb : std_logic;
    signal clk_manual : std_logic;
    signal clk_src : std_logic;
    
begin

    debouncer_i:entity debouncer
    port map(
        clk => clk_100MHz,
        button_in => clk_btn,
        button_out => clk_btn_deb
    );
  
    edge_det_i:entity edge_det
    port map(
        clk => clk_100MHz,
        n_rst => n_rst,
        inp => clk_btn_deb,
        det_edge => clk_manual
        );

    clk_divider_i:entity clk_divider
    port map(
        clk_100MHz => clk_100MHz,
        clk_div => clk_div
    );
    
    clk_switch:process(clk_100MHz)
    begin
        if(clk_100MHz'event and clk_100MHz = '1') then
            if(clk_sel = '1') then
                clk_src <= clk_manual;
            else 
                clk_src <= clk_div;
            end if;
        end if;
    end process;

    clk_out <= clk_src;
    
end architecture;