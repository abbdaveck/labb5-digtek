
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MUX2x8 is
    port(
        IN0 : in std_logic_vector(7 downto 0);
        IN1 : in std_logic_vector(7 downto 0);
        SEL : in std_logic;
        O : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behaviour of MUX2x8 is

begin
    
    with SEL select O <= 
        IN0 when '0',
        IN1 when others;
    
end architecture;