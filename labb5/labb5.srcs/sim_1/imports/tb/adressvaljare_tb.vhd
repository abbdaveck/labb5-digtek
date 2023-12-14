
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;
use work.cpu_pkg.all;

entity adressvaljare_tb is
end entity;

architecture tb of adressvaljare_tb is
    
    signal clk : std_logic := '0';
    signal n_rst : std_logic := '0';
    signal DATA : std_logic_vector(5 downto 0);
    signal A : std_logic_vector(5 downto 0);
    signal AddrSrc : std_logic_vector(1 downto 0);
    signal StackOp : std_logic_vector(1 downto 0);
    signal pc_debug : std_logic_vector(5 downto 0);
   
    signal message : string(1 to 10) := "     RESET";
    signal loop_cnt : integer range 0 to 4;
    signal sim_done : std_logic := '0';
    constant clk_period : time := 100 ns;

    
begin

    DUT_i: entity adressvaljare port map(
        clk => clk,
        n_rst => n_rst,
        DATA => DATA,
        A => A,
        AddrSrc => AddrSrc,
        StackOp => StackOp,
        pc_debug => pc_debug
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
        -- Nollställning av kretsen, nuvarande adress 000000
        wait until clk'event and clk='1';
        n_rst <= '0';
        StackOp <= STACK_OP_HOLD;
        AddrSrc <=ADDR_PC_PLUS_ONE;
        DATA <= "000000";
        message <= "     RESET";
        
        -- PC+1
        -- Sekventiellt programflöde, nuvarande adress går från 000000 till 000100
        for loop_cnt in 0 to 3 loop
            wait until clk'event and clk='1';
            message <= "      PC+1";
            n_rst <= '1';
            StackOp <= STACK_OP_HOLD;
            AddrSrc <=ADDR_PC_PLUS_ONE;
            DATA <= "000000";
        end loop;
        
        -- DATA BRANCH
        -- Programhopp, nästa adress ges av DATA från instruktionen, här 001000.
        wait until clk'event and clk='1';
        message <= "    DATA B";
        n_rst <= '1';
        StackOp <= STACK_OP_HOLD;
        AddrSrc <=ADDR_DATA;
        DATA <= "001000";

        -- PC+1
        -- Sekventiellt programflöde, nästa adress är 001001
        wait until clk'event and clk='1';
        message <= "      PC+1";
        n_rst <= '1';
        StackOp <= STACK_OP_HOLD;
        AddrSrc <=ADDR_PC_PLUS_ONE;
        DATA <= "001000";
        
        -- DATA CALL
        -- Subrutinsanrop, nästa adress i ordningen PC+1 = 001010 sparas på stacken.
        -- Nästa adress ges av DATA = 011000.
        wait until clk'event and clk='1';
        message <= " DATA CALL";
        n_rst <= '1';
        StackOp <= STACK_OP_PUSH;
        AddrSrc <= ADDR_DATA;
        DATA <= "011000";
        
        -- PC+1
        -- Sekventiellt programflöde, nästa adress 011001.
        wait until clk'event and clk='1';
        message <= "      PC+1";
        n_rst <= '1';
        StackOp <= STACK_OP_HOLD;
        AddrSrc <=ADDR_PC_PLUS_ONE;
        DATA <= "001000";
        
        -- ToS RET
        -- Återhoppp från subrutin, nästa adress ges av det översta på stacken 001010.
        wait until clk'event and clk='1';
        message <= "       ToS";
        n_rst <= '1';
        StackOp <= STACK_OP_POP;
        AddrSrc <= ADDR_TOS;
        DATA <= "001000";
        
        -- ToS RET
        -- Återhopp från subrutin. Stacken ska bara innehålla adress 000000 nu.
        wait until clk'event and clk='1';
        message <= "       ToS";
        n_rst <= '1';
        StackOp <= STACK_OP_POP;
        AddrSrc <= ADDR_TOS;
        DATA <= "001000";
        
        -- PC+1
        -- Sekventiellt pgramflöde, nästa adress 000001.
        wait until clk'event and clk='1';
        message <= "      PC+1";
        n_rst <= '1';
        StackOp <= STACK_OP_HOLD;
        AddrSrc <=ADDR_PC_PLUS_ONE;
        DATA <= "001000";
        
        -- RESET
        -- Nollställning, nuvarande adress är 000000
        wait until clk'event and clk='1';
        message <= "     RESET";
        n_rst <= '0';
        StackOp <= STACK_OP_HOLD;
        AddrSrc <=ADDR_PC_PLUS_ONE;
        DATA <= "001000";
        
        wait for 100 ns;
        sim_done <= '1';
        wait;
    
    end process;
    
end architecture;