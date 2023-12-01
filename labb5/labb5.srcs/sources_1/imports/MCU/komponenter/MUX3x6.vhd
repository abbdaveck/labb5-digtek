
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX3x6 is
    port(
        IN0 : in std_logic_vector(5 downto 0);
        IN1 : in std_logic_vector(5 downto 0);
        IN2 : in std_logic_vector(5 downto 0);
        SEL : in std_logic_vector(1 downto 0);
        O : out std_logic_vector(5 downto 0)
    );
end entity;

architecture behaviour of MUX3x6 is

begin
    
    with SEl select O <= 
        IN0 when "00",
        IN1 when "01",
        IN2 when others;
    
end architecture;