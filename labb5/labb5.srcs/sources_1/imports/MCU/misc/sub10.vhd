library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sub10 is
    port (
        sub_in : in  std_logic_vector(4 downto 0);
        sub_out : out std_logic_vector(3 downto 0);
        geq : out std_logic
    );
end sub10;

architecture behaviour of sub10 is

    signal sub_imm : std_logic_vector(3 downto 0);
    signal geq_imm : std_logic;
    
begin

    sub_if_geq_10 : process (sub_in)
    begin
        
        if(unsigned(sub_in) > 9) then
            sub_imm <= std_logic_vector(resize(unsigned(sub_in) - 10, 4));
            geq_imm <= '1';
        else
            sub_imm <= sub_in(3 downto 0);
            geq_imm <= '0';
        end if;
    end process sub_if_geq_10;
    
    -- Output
    sub_out <= sub_imm;
    geq <= geq_imm;
    
end architecture;