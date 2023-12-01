library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reset_block is
    port(
        clk : in std_logic;
        n_rst : in std_logic;
		n_rst_sys : out std_logic
    );
end entity;

architecture behaviour of reset_block is

	type state_type is (RST_ASSERTED, SYS_RST, RUNNING);
	signal current_state, next_state : state_type;
	
begin
    register_update:process(clk, n_rst)
    begin
        if clk'event and clk='1' then
            current_state <= next_state;
        end if;
    end process;
    
    next_state_and_outout_logic:process(current_state, n_rst)
    begin
        n_rst_sys <= '1';
        next_state <= current_state;
        
        case current_state is
        when RST_ASSERTED =>
            next_state <= SYS_RST;
            n_rst_sys <= '0';
        when SYS_RST =>
            if(n_rst = '1') then    
                next_state <= RUNNING;
            end if;
        when RUNNING =>
            next_state <= RUNNING;
            if (n_rst = '0') then
                next_state <= RST_ASSERTED;
            end if;
        end case;
    end process;

end architecture;
