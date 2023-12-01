----------------------------------------------------------------------------------
-- Namn:        mcu
-- Filnamn:     mcu.vhd
-- Testbench:   *ingen*
--
-- Beskrivning:
--      Toppmodul för mikrokontrollern
--
-- Insignaler:
--      clk_100MHz  - 100 MHz klocka från Nexys4
--      led         - ansluts till de 16 lysdioderna på Nexys4
--      btnCpuReset - synkron resetsignal, aktiv låg ansluts till btnCpuReset på Nexys4
--      JA          - data in, ansluts till kontakten JA
--      clk_sel     - väljer manuell klocka eller 2 Hz klocka, ansluts till strömställare SW15
--      btnC        - tryckknapp för manuell klocka, ansluts till btnC på Nexys4
--
-- Utsignaler:
--      JB          - data ut, ansluts till kontakten JB
--      anode       - ansluts till displayens anoder
--      cathode     - asnluts till displayens katoder
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity mcu is 
    port(
        clk_100MHz: in std_logic;
        --led : out std_logic_vector(15 downto 0);
        --led : out std_logic_vector(15 downto 0);
        JA : in std_logic_vector(7 downto 0);
        btnCpuReset : in std_logic;
        clk_sel : in std_logic;
        btnC : in std_logic;
        JB : out std_logic_vector(7 downto 0);
        anode : out std_logic_vector(7 downto 0);
        cathode : out std_logic_vector(6 downto 0)
    );
end entity;

architecture structural of mcu is

    signal I : std_logic_vector(12 downto 0);
    signal A : std_logic_vector(5 downto 0);
    signal OutEna : std_logic;
    signal clk_sys: std_logic;
    signal n_rst, n_rst_sys : std_logic;
    signal INPUT, OUTPUT : std_logic_vector(7 downto 0);
    signal pc_debug : std_logic_vector(5 downto 0);
    
begin

    n_rst <= btnCpuReset;
    --led <= (15 => clk_cpu, others => '0');
    --led <= (others => '0');
    --led(2 downto 0) <= n_rst & n_rst_mem & n_rst_cpu;
    --led(15 downto 10) <= A;
    --led(9 downto 0) <= (others => '0'); 
    
    minne_i: entity minne port map(
        clk => clk_sys,
		n_rst => n_rst_sys,
        address => A,
        mem_data => I
    );
    
    IOblock_i: entity IOblock port map(
        clk => clk_sys,
        n_rst => n_rst_sys,
        OutEna => OutEna,
        JA => JA,
        JB => JB,
        INPUT => INPUT,
        OUTPUT => OUTPUT
    );
    
    cpu_i: entity cpu port map(
        clk => clk_sys,
        n_rst => n_rst_sys,
        I => I,
        A => A,
        INPUT => INPUT,
        OUTPUT => OUTPUT,
        OutEna => OutEna,
        pc_debug => pc_debug
    );
    
    klockblock_i:entity klockblock port map(
        clk_100MHz => clk_100MHz,
        n_rst => n_rst,
        clk_sel => clk_sel,
        clk_btn => btnC,
        clk_out => clk_sys
    );
    
    reset_block_i: entity reset_block port map(
        clk => clk_sys,
        n_rst => n_rst,
        n_rst_sys => n_rst_sys
    );
		
    debugmodul_i: entity debugmodul port map(
        clk => clk_100MHz,
        n_rst => n_rst_sys,
        pc_debug => pc_debug,
        anode => anode,
        cathode => cathode
    );
    
end architecture;