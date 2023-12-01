
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;

entity stack_tb is
end entity;

architecture tb of stack_tb is
    
    signal clk : std_logic := '0';
    signal n_rst : std_logic := '0';
    signal StackOp : std_logic_vector(1 downto 0);
    signal D, ToS : std_logic_vector(5 downto 0);
    
    signal message : string(1 to 10) := "     RESET";
    signal loop_cnt : integer range 0 to 4;
    signal sim_done : std_logic := '0';
    constant clk_period : time := 100 ns;
    
begin
    
    DUT_i: entity stack port map(
        D => D,
        ToS => ToS,
        clk => clk,
        n_rst => n_rst,
        StackOp => StackOp
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
        message <= "     RESET";
        n_rst <= '0';
        D <= "111111";
        StackOp <= STACK_OP_PUSH;
        
        -- PUSH
        -- 
        for loop_cnt in 1 to 4 loop
            wait until clk'event and clk='1';
            message <= "      PUSH";
            n_rst <= '1';
            D <= std_logic_vector(to_unsigned(loop_cnt, 6));
            StackOp <= STACK_OP_PUSH;
        end loop;
        
        -- POP
        -- 
        for loop_cnt in 1 to 3 loop
            wait until clk'event and clk='1';
            message <= "       POP";
            n_rst <= '1';
            D <= "111111";
            StackOp <= STACK_OP_POP;
        end loop;
        
        -- HOLD
        -- 
        wait until clk'event and clk='1';
        message <= "      HOLD";
        n_rst <= '1';
        D <= "111111";
        StackOp <= STACK_OP_HOLD;
        
        -- RESET
        -- 
        wait until clk'event and clk='1';
        wait until clk'event and clk='1';
        message <= "     RESET";
        n_rst <= '0';
        D <= "111111";
        StackOp <= STACK_OP_HOLD;
        
        wait for 100 ns;
        sim_done <= '1';
        wait;
        
    end process;
    
end architecture;