
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity registerblock_tb is
end entity;

architecture tb of registerblock_tb is

    signal clk : std_logic := '0';
    signal n_rst : std_logic := '0';
    signal F : std_logic_vector(7 downto 0);
    signal DEST : std_logic;
    signal RegEna : std_logic;
    signal RegOut : std_logic_vector(7 downto 0);
    
    signal message : string(1 to 16) := "           RESET";
    signal sim_done : std_logic := '0';
    constant clk_period : time := 100 ns;
    
begin

    DUT_i: entity registerblock port map(
        clk => clk,
        n_rst => n_rst,
        F => F,
        DEST => DEST,
        RegEna => RegEna,
        RegOut => RegOut
    );
    
    clk_gen:process
    begin
        if sim_done  = '0' then
            wait for clk_period / 2;
            clk <= not clk;
        else
            wait;
        end if;
    end process;
    
    wave_gen:process
    begin
        
        -- RESET
        --
        wait until clk'event and clk='1';
        message <= "           RESET";
        n_rst <= '0';
        F <= "11111111";
        RegEna <= '1';
        DEST <= '0';
        
        -- DEST=0, RegEna=1
        -- Ladda R0 med värdet 00001111.
        -- R0s värde ska finnas på utgången RegOut
        wait until clk'event and clk='1';
        message <= "DEST=0, RegEna=1";
        n_rst <= '1';
        F <= "00001111";
        RegEna <= '1';
        DEST <= '0';
        
        -- DEST=1, RegEna=1
        -- Ladda R1 med värdet 01010101.
        -- R1s värde ska finnas på utgången RegOut
        wait until clk'event and clk='1';
        message <= "DEST=1, RegEna=1";
        n_rst <= '1';
        F <= "01010101";
        RegEna <= '1';
        DEST <= '1';

        -- DEST=0, RegEna=0
        -- R0s värde ska finnas på utsignalen RegOut och vara oförändrat
        wait until clk'event and clk='1';
        message <= "DEST=0, RegEna=0";
        n_rst <= '1';
        F <= "11110000";
        RegEna <= '0';
        DEST <= '0';
        
        -- DEST=1, RegEna=0
        -- R1s värde ska finnas på utsignalen RegOut och vara oförändrat
        wait until clk'event and clk='1';
        message <= "DEST=1, RegEna=0";
        n_rst <= '1';
        F <= "00001111";
        RegEna <= '0';
        DEST <= '1';
        
        -- RESET
        -- R0 och R1 ska vara nollställda
        wait until clk'event and clk='1';
        message <= "           RESET";
        n_rst <= '0';
        F <= "00001111";
        RegEna <= '1';
        DEST <= '1';
        
        wait until clk'event and clk='1';
        message <= "           RESET";
        n_rst <= '0';
        F <= "00001111";
        RegEna <= '1';
        DEST <= '0';
        
        wait for 100 ns;
        sim_done <= '1';
        wait;
        
    end process;
    
end architecture;