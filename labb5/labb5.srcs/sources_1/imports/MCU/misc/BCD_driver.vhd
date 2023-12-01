library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BCD_driver is
    port(
        seg0 : in std_logic_vector(3 downto 0);
        seg1 : in std_logic_vector(3 downto 0);
        seg2 : in std_logic_vector(3 downto 0);
        seg3 : in std_logic_vector(3 downto 0);
        seg4 : in std_logic_vector(3 downto 0);
        seg5 : in std_logic_vector(3 downto 0);
        seg6 : in std_logic_vector(3 downto 0);
        seg7 : in std_logic_vector(3 downto 0);
        anode_out : out std_logic_vector(7 downto 0);
        cathode_out : out std_logic_vector(6 downto 0);
        clk_in : in std_logic;
        n_rst_in : in std_logic
    );
end entity BCD_driver;

architecture behavior of BCD_driver is

    type seg_array is array (0 to 7) of std_logic_vector(3 downto 0);
    signal segments : seg_array;
    
    type anode_array is array (0 to 7) of std_logic_vector(7 downto 0);
    signal anodes : anode_array;

    signal seg_cnt : unsigned(2 downto 0) := (others=>'0');
    signal seg_current : std_logic_vector(3 downto 0);
    signal seven_seg : std_logic_vector(6 downto 0);
    constant time_slot : unsigned(17 downto 0) := to_unsigned(250e3 - 1, 18);
    signal cnt : unsigned(17 downto 0) := (others=>'0');
    
begin

    process(clk_in)
    begin
--        if(n_rst_in = '0') then
--            cnt <= (others => '0');
--            seg_cnt <= (others => '0');
            
--        elsif(clk_in'event and clk_in = '1') then
--            if(cnt = time_slot) then
--                cnt <= (others => '0');
--                seg_cnt <= seg_cnt + 1;
            
--            else
--                cnt <= cnt + 1;
--            end if;
--        end if;
        if(clk_in'event and clk_in = '1') then
            if(cnt = time_slot) then
                cnt <= (others => '0');
                seg_cnt <= seg_cnt + 1;
            
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    
    segment_encode: process (seg_current)
    begin  -- process segment_encode
        case seg_current is
            when "0000" => Seven_Seg <= "1000000";  -- 0
            when "0001" => Seven_Seg <= "1111001";  -- 1
            when "0010" => Seven_Seg <= "0100100";  -- 2
            when "0011" => Seven_Seg <= "0110000";  -- 3
            when "0100" => Seven_Seg <= "0011001";  -- 4
            when "0101" => Seven_Seg <= "0010010";  -- 5
            when "0110" => Seven_Seg <= "0000010";  -- 6
            when "0111" => Seven_Seg <= "1111000";  -- 7
            when "1000" => Seven_Seg <= "0000000";  -- 8
            when "1001" => Seven_Seg <= "0010000";  -- 9 
            when "1010" => Seven_Seg <= "0001000";  -- A
            when "1011" => Seven_Seg <= "0000011";  -- b
            when "1100" => Seven_Seg <= "1000110";  -- C
            when "1101" => Seven_Seg <= "1111111";  -- 
            when "1110" => Seven_Seg <= "0111111";  -- -
            when "1111" => Seven_Seg <= "0001110";  -- F
            when others => Seven_Seg <= "1111111";  -- .
        end case;
    end process segment_encode;
   
    segments <= (seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7);
    anodes <= (
        "00000001",
        "00000010",
        "00000100",
        "00001000",
        "00010000",
        "00100000",
        "01000000",
        "10000000"
    );
    
    seg_current <= segments(to_integer(seg_cnt)) when n_rst_in = '1' else "1101";
    cathode_out <= seven_seg;
    anode_out <= not anodes(to_integer(seg_cnt));
    
end architecture behavior;