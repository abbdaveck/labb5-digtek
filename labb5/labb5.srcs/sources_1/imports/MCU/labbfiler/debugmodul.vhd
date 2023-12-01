----------------------------------------------------------------------------------
-- Namn:        debugmodul
-- Filnamn:     debugmodul.vhd
-- Testbench:   *ingen*
--
-- Beskrivning:
--      Binär till 7-segment avkodare.
--      Kretsen genererar signaler till Nexys4 så värdet
--      av signalen pc_debug visas på displayen.
--
-- Insignaler:
--      clk      - klocksignal, all uppdatering av register sker vid stigande flank
--      n_rst    - synkron resetsignal, aktiv låg
--      pc_debug - nuvarande adress PC
--
-- Utsignaler:
--      anode       - ansluts till displayens anoder
--      cathode     - ansluts till displayens katoder
----------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.all;   

entity debugmodul is
    port(
        clk : in std_logic;
        n_rst: in std_logic;
        pc_debug : in std_logic_vector(5 downto 0);
        anode : out std_logic_vector(7 downto 0);
        cathode : out std_logic_vector(6 downto 0)
    );
end entity debugmodul;

architecture behavior of debugmodul is
   
    signal seg0_imm, seg1_imm, seg2_imm, seg3_imm : std_logic_vector(3 downto 0);
    signal A_tens, A_ones : std_logic_vector(3 downto 0);

begin

    NBCD_i: entity nbcd port map(
        binary => pc_debug,
        tens => A_tens,
        ones => A_ones
    );
    
    BCD_driver_i: entity BCD_driver port map(
        seg0 => seg0_imm,
        seg1 => seg1_imm,
        seg2 => seg2_imm,
        seg3 => seg3_imm,
        seg4 => (others=>'0'),
        seg5 => (others=>'0'),
        seg6 => (others=>'0'),
        seg7 => (others=>'0'),
        anode_out => anode,
        cathode_out => cathode,
        clk_in => clk,
        n_rst_in => n_rst
    );
    
    seg0_imm <= A_ones;
    seg1_imm <= A_tens;
    seg2_imm <= "0000";
    seg3_imm <= "0000";

end architecture behavior;