
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity REG8 is
    port(
        CLK : in std_logic;
        CLR : in std_logic;
        ENA : in std_logic;
        D : in std_logic_vector(7 downto 0);
        Q : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behaviour of REG8 is

begin
    reg_update:process(CLK)
    begin
        if(CLK'event and CLK='1') then
            if CLR = '0' then
                    Q <= "00000000";
            elsif(ENA = '1') then
                Q <= D;
            end if;
        end if;
end process;

end architecture;