----------------------------------------------------------------------------------
-- Namn:        adressvaljare
-- Filnamn:     adressvaljare.vhd
-- Testbench:   adressvaljare_tb.vhd
--
-- Insignaler:
--      clk     - klocksignal, all uppdatering av register sker vid stigande flank
--      n_rst   - synkron resetsignal, aktiv låg
--      DATA    - de 6 minst signifikanta bitarna från instruktionen, används då 
--                nästa adress anges av instruktionen
--      AddrSrc - bestämmer varifrån nästa adress ska hämtas
--      StackOp - styr stacken i adressväljaren
--
-- Utsignaler:
--      A           - nästa adress
--      pc_debug    - nuvarande adress, används för att visa adressen på 
--                    Nexys4 display
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;

entity adressvaljare is
    port(
        clk, n_rst : in std_logic;
        DATA : in std_logic_vector(5 downto 0);
        A : out std_logic_vector(5 downto 0);
        AddrSrc : in std_logic_vector(1 downto 0);
        StackOp : in std_logic_vector(1 downto 0);
        pc_debug : out std_logic_vector(5 downto 0)
    );
end entity;

architecture structural of adressvaljare is
    signal PC_1, ToS, mux_out, reg_out: std_logic_vector(5 downto 0); 
    signal ALU_in, ALU_out : std_logic_vector(7 downto 0);
begin
    ALU_in <= "00" & reg_out;
    pc_debug <= reg_out;
    A <= mux_out;
    PC_1 <= ALU_out(5 downto 0);
    
    REG_6: entity REG6 port map (
    CLK => clk,
    CLR => n_rst,
    ENA => '1',
    D => mux_out,
    Q => reg_out
    );
    
    stack_entiy: entity stack port map (
    D => PC_1,
    ToS => ToS,
    CLK => clk,
    n_rst => n_rst,
    StackOp => StackOp
    );
    
    alu: entity ALU8 port map (
    B => ALU_in,
    A => "00000001",
    S => "010",
    Z => open, 
    F => ALU_out
    );
    
    mux: entity MUX3x6 port map (
    IN0 => PC_1,
    IN1 => DATA,
    IN2 => ToS,
    SEL => AddrSrc,
    O => mux_out
    );

    
end architecture;