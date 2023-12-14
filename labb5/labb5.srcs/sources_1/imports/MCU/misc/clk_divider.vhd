
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clk_divider is
    port(
        clk_100MHz : in std_logic;
        clk_div : out std_logic
    );
end entity;

architecture behaviour of clk_divider is

    signal cnt : std_logic_vector(15 downto 0);
    signal clk_int : std_logic;
    
begin
    
    reg_update:process(clk_100MHz)
    begin
        if(rising_edge(clk_100MHz)) then
--            if(n_rst = '0') then
--                cnt <= (others=>'0');
--                clk_int <= '0';
--            elsif(unsigned(cnt) = (5e4 - 1)) then -- 1kHz
--                clk_int <= not clk_int;                
--                cnt <= (others=>'0');
--            else
--                cnt <= std_logic_vector(unsigned(cnt) + 1);
--            end if;
            if(unsigned(cnt) = (5e4 - 1)) then -- 1kHz
                clk_int <= not clk_int;                
                cnt <= (others=>'0');
            else
                cnt <= std_logic_vector(unsigned(cnt) + 1);
            end if;
        end if;
    end process;
    
    clk_div <= clk_int;
    
end architecture;