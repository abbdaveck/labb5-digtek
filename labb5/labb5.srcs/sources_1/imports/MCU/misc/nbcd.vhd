
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;

entity nbcd is
    port (
        binary : in  std_logic_vector(5 downto 0);
        tens : out std_logic_vector(3 downto 0);
        ones : out std_logic_vector(3 downto 0)
    );
end entity nbcd;

architecture structural of nbcd is

    -- Declare all internal signals of the NBCD decoder here
    signal zero : std_logic;
    signal sub_in1, sub_in2,sub_in3 : std_logic_vector(4 downto 0);
    signal sub_out1, sub_out2, sub_out3 : std_logic_vector(3 downto 0);
    signal geq1, geq2, geq3 : std_logic;
    
    
begin
    zero <= '0';

    -- Wire signals
    sub_in3 <= zero & binary(5 downto 2);
    sub_in2 <= sub_out3 & binary(1);
    sub_in1 <= sub_out2 & binary(0);
    
    sub10_3: entity sub10 port map (
            sub_in => sub_in3,
            sub_out => sub_out3,
            geq => geq3
            );  
    
    sub10_2: entity sub10 port map (
            sub_in => sub_in2,
            sub_out => sub_out2,
            geq => geq2
        );              
    
    sub10_1: entity sub10 port map (
        sub_in => sub_in1,
        sub_out => sub_out1,
        geq => geq1
        );

    -- TODO:    Connect the output signals
    tens <= zero & geq3 & geq2 & geq1;
    ones <= sub_out1;
     
end architecture;
