
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU8 is
    port(
        A : in std_logic_vector(7 downto 0);
        B : in std_logic_vector(7 downto 0);
        S : in std_logic_vector(2 downto 0);
        Z : out std_logic;
        F : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behaviour of ALU8 is

    signal F_int : std_logic_vector(7 downto 0);
    
begin

    with S select F_int <= 
        A when "000",
        B when "001",
        std_logic_vector(signed(A) + signed(B)) when "010",
        std_logic_vector(signed(B) - signed(A)) when "011",
        A and B when "100",
        A or B when "101",
        A xor B when "110",
        "00000000" when others;
        
    Z <= '1' when F_int="00000000" else '0';
    F <= F_int;
    
end architecture;