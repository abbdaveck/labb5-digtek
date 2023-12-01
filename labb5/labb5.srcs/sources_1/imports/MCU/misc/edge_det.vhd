library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity edge_det is
  port (
    clk, n_rst : in  std_logic;
    inp        : in  std_logic;
    det_edge   : out std_logic
    );
end entity;

architecture edge_det_arch of edge_det is

  signal reg_q, reg_q_next : std_logic;

begin

    reg : process (clk, n_rst) is
    begin
        if(n_rst <= '0') then
            reg_q <= '0';
        elsif(clk'event and clk='1') then
            reg_q <= reg_q_next;
        end if;
    end process reg;

    comb:process(reg_q, inp) is
    begin
    
        reg_q_next <= reg_q;
        
        case reg_q is
        when '0' =>
            if(inp = '1') then
                reg_q_next <= '1';
            end if;
        when others =>
            if(inp = '0') then
                reg_q_next <= '0';
            end if;
        end case;
    end process;

    det_edge <= (not reg_q) and inp;
    
end architecture;
