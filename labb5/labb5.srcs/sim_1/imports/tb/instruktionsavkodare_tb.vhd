
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;

entity instruktionsavkodare_tb is
end entity;

architecture behaviour of instruktionsavkodare_tb is
    
    signal OPCODE : std_logic_vector(3 downto 0);
    signal Z : std_logic;
    signal StackOp : std_logic_vector(1 downto 0);
    signal AddrSrc : std_logic_vector(1 downto 0);
    signal ALUOp : std_logic_vector(2 downto 0);
    signal ALUSrc : std_logic;
    signal RegEna : std_logic;
    signal OutEna : std_logic;
    
    constant some_time : time := 100 ns;
    signal message : string(1 to 4);
    
begin

    DUT_i: entity instruktionsavkodare port map(
        OPCODE => OPCODE,
        Z => Z,
        StackOp => StackOp,
        AddrSrc => AddrSrc,
        ALUOp => ALUOp,
        ALUSrc => ALUSrc,
        RegEna => RegEna,
        OutEna => OutEna
    );  
    
    wavegen:process
    begin
    
        Z <= '0';
        OPCODE <= OPCODE_CALL;
        message <= "CALL";
        wait for some_time;
        
        OPCODE <= OPCODE_RET;
        message <= " RET";
        wait for some_time;
        
        OPCODE <= OPCODE_BZ;
        message <= "  BZ";
        wait for some_time;
        Z <= '1';
        wait for some_time;
        
        OPCODE <= OPCODE_B;
        message <= "   B";
        wait for some_time;
        
        OPCODE <= OPCODE_ADD;
        message <= " ADD";
        wait for some_time;
        
        OPCODE <= OPCODE_SUB;
        message <= " SUB";
        wait for some_time;
        
        OPCODE <= OPCODE_LD;
        message <= "  LD";
        wait for some_time;
        
        OPCODE <= OPCODE_OUT;
        message <= " OUT";
        wait for some_time;
        
        OPCODE <= OPCODE_IN;
        message <= "  IN";
        wait for some_time;
        
        OPCODE <= OPCODE_AND;
        message <= " AND";
        wait for some_time;
        
        wait;
    end process;

end architecture;