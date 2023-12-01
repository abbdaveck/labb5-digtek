----------------------------------------------------------------------------------
-- Namn:        berakningsenhet
-- Filnamn:     berakningsenhet.vhd
-- Testbench:   berakningsenhet_tb.vhd
--
-- Insignaler:
--      clk     - klocksignal, all uppdatering av register sker vid stigande flank
--      n_rst   - synkron resetsignal, aktiv låg
--      DATA    - data från instruktionen
--      INPUT   - insignalen JA synkroniserad i IO-blocket
--      DEST    - väljer om R0 eller R1 i registerblocket ska vara aktivt
--      ALUsrc  - väljer om det asktiva registret eller insignalen JA från IO-blocket 
--                ska användas som operand till ALU
--      ALUop   - styr vilken operation ALu ska utföra
--      RegEna  - laddsignal till registerblocket, högt värde medför att det aktiva 
--                registret ska uppdateras med resultatet från ALU
--
-- Utsignaler:
--      OUTPUT - data som ska skrivs till signalen JB
--      Z      - zero-flagga, hög om resultet från ALU är noll
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;


entity berakningsenhet is
    signal 
    port(
        clk, n_rst : in std_logic;
        DATA : in std_logic_vector(7 downto 0);
        INPUT : in std_logic_vector(7 downto 0);
        DEST : in std_logic;
        ALUSrc : in std_logic;
        ALUOp : in std_logic_vector(2 downto 0);
        RegEna : in std_logic;
        OUTPUT : out std_logic_vector(7 downto 0);
        Z : out std_logic
    );
end entity;

architecture structural of berakningsenhet is
    signal ALU_in, ALU_out, MUX_OUT, REG_OUT : std_logic_vector(7 downto 0);
    ALU: entity ALU8 port map (
        B => MUX_OUT,
        A => DATA,
        S => ALUOp,
        Z => Z, 
        F => ALU_OUT
    );
    
    REG_8: entity REG8 port map (
        CLK => clk,
        CLR => n_rst,
        ENA => RegEna,
        D => ALU_OUT,
        Q => reg_out
    );
    MUX2: entity MUX2x8 port map (
        IN0 => INPUT,
        IN1 => Reg_out,
        SEL => ALUSrc,
        O => MUX_OUT
    );
    REGBLOCK: entity registerblock port map (
        clk => CLK,
        n_rst => n_rst,
        F => ALU_OUT,
        DEST => DEST,
        RegEna => RegEna,
        RegOut => REG_OUT
    );
begin
    
end architecture;