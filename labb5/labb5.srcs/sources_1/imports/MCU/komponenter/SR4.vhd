
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SR4 is
    port(
        CLR : in std_logic;
        CLK : in std_logic;
        SR_SER, SL_SER : in std_logic;
        S0, S1 : in std_logic;
        QA, QB, QC, QD : out std_logic
    );
end entity;

architecture behaviour of SR4 is

    signal Q, Q_next : std_logic_vector(3 downto 0);
    signal S : std_logic_vector(1 downto 0);
    
begin
    
    S <= S1 & S0;

    reg_update:process(CLK)
    begin    
        if(CLK'event and CLK = '1') then
            if (CLR = '0') then
                    Q <= "0000";
            else
                Q <= Q_next;
            end if;
        end if;
    end process;
    
    comb:process(S, SR_SER, SL_SER, Q)
    begin
        Q_next <= Q;
        
        case S is
            when "00" =>
                Q_next <= Q;
            when "01" =>
                Q_next <= Q(2 downto 0) & SR_SER;
            when others =>
                Q_next <= SL_SER & Q(3 downto 1);
                
        end case;
    end process;
    
    QA <= Q(0);
    QB <= Q(1);
    QC <= Q(2);
    QD <= Q(3);
end architecture;