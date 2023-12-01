
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;

entity berakningsenhet_tb is
end entity;

architecture behaviour of berakningsenhet_tb is

    signal clk : std_logic := '0';
    signal n_rst : std_logic := '0';
    signal DATA : std_logic_vector(7 downto 0);
    signal INPUT : std_logic_vector(7 downto 0);
    signal OUTPUT : std_logic_vector(7 downto 0);
    signal Z : std_logic;
    signal DEST : std_logic;
    signal ALUSrc : std_logic;
    signal ALUOp : std_logic_vector(2 downto 0);
    signal RegEna : std_logic;
    
    signal message : string(1 to 16) := "           RESET";
    signal loop_cnt : integer range 0 to 4;
    signal sim_done : std_logic := '0';
    constant clk_period : time := 100 ns;
        
begin

    DUT_i: entity berakningsenhet port map(
        clk => clk,
        n_rst => n_rst,
        DATA => DATA,
        INPUT => INPUT,
        OUTPUT => OUTPUT,
        Z => Z,
        DEST => DEST,
        ALUSrc => ALUSrc,
        ALUOp => ALUOp,
        RegEna => RegEna
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
        DATA <= "11111111";
        INPUT <= "01010101";
        DEST <= '0';
        ALUSrc <= '0';
        ALUOp <= "111";
        RegEna <= '0';
        
        -- Ladda R0 med värdet från INPUT=00001000
        -- OUTPUT ska vara detsamma och Z=0
        wait until clk'event and clk='1';
        message <= "LOAD R0=00001000";
        n_rst <= '1';
        DATA <= "00000000";
        INPUT <= "00001000";
        DEST <= '0';
        ALUSrc <= '1';
        ALUOp <= "001";
        RegEna <= '1';
        
        -- Läs R0 och verifiera dess värde, ska vara 00001000
        --
        wait until clk'event and clk='1';
        message <= "         READ R0";
        n_rst <= '1';
        DATA <= "00000000";
        INPUT <= "00000000";
        DEST <= '0';
        ALUSrc <= '0';
        ALUOp <= "001";
        RegEna <= '0';
        
        -- Ladda R1 med värdet från DATA=10000000
        -- OUTPUT ska vara detsamma och Z=0
        wait until clk'event and clk='1';
        message <= "LOAD R1=10000000";
        n_rst <= '1';
        DATA <= "10000000";
        INPUT <= "01010101";
        DEST <= '1';
        ALUSrc <= '1';
        ALUOp <= "000";
        RegEna <= '1';
        
        -- Läs R1 och verifiera dess värde, ska vara 10000000
        --
        wait until clk'event and clk='1';
        message <= "         READ R1";
        n_rst <= '1';
        DATA <= "00000000";
        INPUT <= "00000000";
        DEST <= '1';
        ALUSrc <= '0';
        ALUOp <= "001";
        RegEna <= '0';
        
        -- OUTPUT = R0 - DATA = 00000000, Z=1
        -- R0s värde ska inte ändras 
        wait until clk'event and clk='1';
        message <= "  OUTPUT=R0-DATA";
        n_rst <= '1';
        DATA <= "00001000";
        INPUT <= "01010101";
        DEST <= '0';
        ALUSrc <= '0';
        ALUOp <= "011";
        RegEna <= '0';
        
        -- Läs R0 och verifiera dess värde, ska vara 00001000
        --
        wait until clk'event and clk='1';
        message <= "         READ R0";
        n_rst <= '1';
        DATA <= "00000000";
        INPUT <= "00000000";
        DEST <= '0';
        ALUSrc <= '0';
        ALUOp <= "001";
        RegEna <= '0';

        wait until clk'event and clk='1';
        sim_done <= '1';
        wait;
    
    end process;
    
    
end architecture;