--
-- Denna TB kommer att köra igenom följande program
--
-- 00 LD   R0  1
-- 01 ADD  R0  2
-- 02 IN   R1 
-- 03 OUT  R1
-- 04 BZ   R1  20
-- 05 SUB  R1  4
-- 06 BZ   R1  20
-- ...
-- 20 B        24
-- ...
-- 24 CALL     30
-- 25 B        0
-- ..
-- 30 ADD  R1  1
-- 31 RET
--
-- Signalerna A, OutEna och OUTPUT kommer att jämföras med rätt värde. Skulle
-- ett fel upptäckas så rapporteras detta i Transcript-fönstret.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.all;
use work.cpu_pkg.all;

entity cpu_tb is
end entity;

architecture tb of cpu_tb is
    
    signal clk : std_logic := '0';
    signal n_rst : std_logic := '0';
    signal DATA : std_logic_vector(7 downto 0);
    signal DEST : std_logic;
    signal OPCODE : std_logic_vector(3 downto 0);
    signal I : std_logic_vector(12 downto 0);
    signal A, PC : std_logic_vector(5 downto 0);
    signal INPUT, OUTPUT : std_logic_vector(7 downto 0);
    signal OutEna : std_logic;
    
   
    signal message : string(1 to 11) := "      RESET";
    type opcode_arr is array (1 to 10) of string(1 to 4);
    constant opcode_str : opcode_arr := ("CALL", " RET", "  BZ", "   B", " ADD", " SUB", " AND", "  LD", " OUT", "  IN");
    
    signal loop_cnt : integer range 0 to 4;
    signal sim_done : std_logic := '0';
    constant clk_period : time := 100 ns;
    
    --function create_message (opcode_str : string(1 to 4); DEST : std_logic; DATA : std_logic_vector(7 downto 0)) return string(1 to 10);
    pure function create_message
        (opcode : string(1 to 4);
         dest : std_logic;
         data : integer)
         return string is
         variable reg : string(1 to 2);
         variable data_str1 : string(1 to 1);
         variable data_str2 : string(1 to 2);
         variable data_str3, data_str : string(1 to 3);
    begin
        if dest = '1' then
            reg := "R1";
        elsif dest = '0' then
            reg := "R0";
        else 
            reg := "  ";
        end if;
        
        if data < 0 then
            data_str := "   ";
        elsif data < 10 then
            data_str1 := integer'image(data);
            data_str := "  " & data_str1;
        elsif data < 100 then
            data_str2 := integer'image(data);
            data_str := " " & data_str2;
        else
            data_str3 := integer'image(data);
            data_str := data_str3;
        end if;
        
        return opcode & " " & reg & " " & data_str;
        
    end function;
    
begin

    I <= OPCODE & DEST & DATA;

    DUT_i: entity cpu port map(
        clk => clk,
        n_rst => n_rst,
        I => I,
        INPUT => INPUT,
        A => A,
        OUTPUT => OUTPUT,
        OutEna => OutEna,
        pc_debug => PC
    );
    
    clk_gen:process
    begin
        if sim_done  = '0' then
            wait for clk_period / 2;
            clk <= not clk;
        else
            wait;
        end if;
    end process;

    wave_gen:process
    begin
        
        -- System reset
        n_rst <= '0';
        OPCODE <= (others => '0');
        DEST <= '0';
        DATA <= (others => '0');
        INPUT <= (others => '0');
        wait until clk'event and clk='1';
        wait until clk'event and clk='1';
        wait until clk'event and clk='1';
        

        --00 LD R0 1
        n_rst <= '1';
        OPCODE <= OPCODE_LD;
        DEST <= '0';
        DATA <= std_logic_vector(to_unsigned(1, 8));
        message <= create_message(opcode_str(8),'0', 1);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(1, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 1!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        assert OUTPUT = std_logic_vector(to_unsigned(1, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 1!!" severity error;
        wait until clk'event and clk='1';
        
        --01 ADD R0 2
        OPCODE <= OPCODE_ADD;
        DEST <= '0';
        DATA <= std_logic_vector(to_unsigned(2, 8));
        message <= create_message(opcode_str(5),'0', 2);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(2, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 2!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        assert OUTPUT = std_logic_vector(to_unsigned(3, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 3!!" severity error;
        wait until clk'event and clk='1';
        
        -- INPUT = 4
        --02 IN R1
        INPUT <= std_logic_vector(to_unsigned(4, 8));
        OPCODE <= OPCODE_IN;
        DEST <= '1';
        DATA <= std_logic_vector(to_unsigned(0, 8));
        message <= create_message(opcode_str(10),'1', -1);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(3, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 3!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        assert OUTPUT = std_logic_vector(to_unsigned(4, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 4!!" severity error;
        wait until clk'event and clk='1';
        
        --03 OUT R1
        INPUT <= std_logic_vector(to_unsigned(0, 8));
        OPCODE <= OPCODE_OUT;
        DEST <= '1';
        DATA <= std_logic_vector(to_unsigned(0, 8));
        message <= create_message(opcode_str(9),'1', -1);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(4, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 4!!" severity error;
        assert OutEna = '1' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '1'!!" severity error;
        assert OUTPUT = std_logic_vector(to_unsigned(4, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 4!!" severity error;
        wait until clk'event and clk='1';
        
        --04 BZ R1 20
        OPCODE <= OPCODE_BZ;
        DEST <= '1';
        DATA <= std_logic_vector(to_unsigned(20, 8));
        message <= create_message(opcode_str(3),'1', 20);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(5, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 5!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        assert OUTPUT = std_logic_vector(to_unsigned(4, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 4!!" severity error;
        wait until clk'event and clk='1';
        
        --05 SUB R1 4
        OPCODE <= OPCODE_SUB;
        DEST <= '1';
        DATA <= std_logic_vector(to_unsigned(4, 8));
        message <= create_message(opcode_str(6),'1', 4);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(6, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 6!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        assert OUTPUT = std_logic_vector(to_unsigned(0, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 0!!" severity error;
        wait until clk'event and clk='1';
        
        --06 BZ R1 20
        OPCODE <= OPCODE_BZ;
        DEST <= '1';
        DATA <= std_logic_vector(to_unsigned(20, 8));
        message <= create_message(opcode_str(3),'1', 20);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(20, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 20!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        assert OUTPUT = std_logic_vector(to_unsigned(0, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 0!!" severity error;
        wait until clk'event and clk='1';
        
        --20 B 24
        OPCODE <= OPCODE_B;
        DEST <= '1';
        DATA <= std_logic_vector(to_unsigned(24, 8));
        message <= create_message(opcode_str(4), 'X', 24);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(24, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 24!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        --assert OUTPUT = std_logic_vector(to_unsigned(0, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 0!!" severity error;
        wait until clk'event and clk='1';
        
        --24 CALL 30
        OPCODE <= OPCODE_CALL;
        DEST <= '1';
        DATA <= std_logic_vector(to_unsigned(30, 8));
        message <= create_message(opcode_str(1), 'X', 30);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(30, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 30!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        --assert OUTPUT = std_logic_vector(to_unsigned(0, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 0!!" severity error;
        wait until clk'event and clk='1';
        
        --30 ADD R1 1
        OPCODE <= OPCODE_ADD;
        DEST <= '1';
        DATA <= std_logic_vector(to_unsigned(1, 8));
        message <= create_message(opcode_str(5), '1', 1);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(31, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 31!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        assert OUTPUT = std_logic_vector(to_unsigned(1, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 1!!" severity error;
        wait until clk'event and clk='1';
        
        --31 RET
        OPCODE <= OPCODE_RET;
        DEST <= '1';
        DATA <= std_logic_vector(to_unsigned(1, 8));
        message <= create_message(opcode_str(2), 'X', -1);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(25, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 25!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        --assert OUTPUT = std_logic_vector(to_unsigned(0, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 0!!" severity error;
        wait until clk'event and clk='1';
        
         --25 B 0
        OPCODE <= OPCODE_B;
        DEST <= '1';
        DATA <= std_logic_vector(to_unsigned(0, 8));
        message <= create_message(opcode_str(4), 'X', 0);
        wait for clk_period / 2;
        assert A = std_logic_vector(to_unsigned(0, 6)) report "A = " & integer'image(to_integer(unsigned(A))) & ", ska vara 0!!" severity error;
        assert OutEna = '0' report "OutEna = " & std_logic'image(OutEna) & ", ska vara '0'!!" severity error;
        --assert OUTPUT = std_logic_vector(to_unsigned(0, 8)) report "OUTPUT = " & integer'image(to_integer(unsigned(OUTPUT))) & ", ska vara 0!!" severity error;
        wait until clk'event and clk='1';
        
        n_rst <= '0';
        sim_done <= '1';
        wait;
    
    end process;
end architecture;

