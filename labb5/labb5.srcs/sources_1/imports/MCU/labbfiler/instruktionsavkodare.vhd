----------------------------------------------------------------------------------
-- Namn:        instruktionsavkodare
-- Filnamn:     instruktionsavkodare.vhd
-- Testbench:   instruktionsavkodare_tb.vhd
--
-- Insignaler:
--      OPCODE - operationskod från instruktionen
--      Z      - zero-flagga från beräkningsenhet
--
-- Utsignaler:
--      StackOp - styr stacken i adressväljaren
--      AddrSrc - styr varifrån nästa adress ska hämtas
--      ALUOp   - bestämmer operatinen för ALU i beräkningsenhet
--      ALUSrc  - väljer om ett register eller insignalen från IO-blocket ska 
--                vara operand till ALU
--      RegEna  - laddsignal till registerblocket
--      OutEna  - laddsignal till utsignalsregistret i IO-blocket
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;

entity instruktionsavkodare is
    port(
        OPCODE : in std_logic_vector(3 downto 0);
        Z : in std_logic;
        StackOp : out std_logic_vector(1 downto 0);
        AddrSrc : out std_logic_vector(1 downto 0);
        ALUOp : out std_logic_vector(2 downto 0);
        ALUSrc : out std_logic;
        RegEna : out std_logic;
        OutEna : out std_logic
    );
end entity;

architecture behaviour of instruktionsavkodare is
begin 
    decode : process (OPCODE,Z)    
    begin
        StackOp <= STACK_OP_PUSH;
        AddrSrc <= ADDR_PC_PLUS_ONE;
        ALUSrc <= '0';
        ALUOp <= "000";
        RegEna <= '0';
        OutEna <= '0';
    
    case OPCODE is
        when OPCODE_CALL =>
            StackOp <= STACK_OP_PUSH;
            AddrSrc <= ADDR_DATA;
        when OPCODE_RET =>
            StackOp <= STACK_OP_POP;
            AddrSrc <= ADDR_TOS;
        when OPCODE_BZ =>
            ALUOp <= ALU_OP_B;
            if (Z = '1') then
                AddrSrc <= ADDR_DATA;
            end if;
        when OPCODE_B => 
            AddrSrc <= ADDR_DATA;
        when OPCODE_ADD =>
            RegEna <= '1';
            ALUOp <= ALU_OP_A_ADD_B;
        when OPCODE_SUB =>
            ALUOp <= ALU_OP_B_SUB_A;
            RegEna <= '1';
        when OPCODE_LD =>
            RegEna <= '1';
        when OPCODE_IN =>
            ALUOp <= ALU_OP_B;
            ALUSrc <= '1';
            RegEna <= '1';
        when OPCODE_OUT =>
            ALUOp <= ALU_OP_B;
            OutEna <= '1';
        when OPCODE_AND =>
            ALUOp <= ALU_OP_AND;
            RegEna <= '1';
            when others => null;
                end case;
         end process;

end architecture;