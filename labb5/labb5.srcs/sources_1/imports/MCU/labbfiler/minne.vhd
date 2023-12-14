----------------------------------------------------------------------------------
-- Namn:        minne
-- Filnamn:     minne.vhd
-- Testbench:   *ingen*
--
-- Beskrivning:
--      Minnes för MCU. Ett av Nexys4 18K-bit RAM block (RAMB18E1) används för att 
--      implementera ett minne med storleken 32x13bit.
--
-- Insignaler:
--      clk     - klocksignal, all uppdatering av register sker vid stigande flank
--      n_rst   - synkron resetsignal, aktiv låg 
--      address - adressen till raden som ska läsas
--
-- Utsignaler:
--      mem_data - innehållet från raden som läst av
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library UNISIM;
use UNISIM.vcomponents.all;

entity minne is
    port(
        address : in std_logic_vector(5 downto 0);
        mem_data : out std_logic_vector(12 downto 0);
        clk : in std_logic;
        n_rst : in std_logic
    );
end entity;

architecture behaviour of minne is

    signal tmp_data : std_logic_vector(15 downto 0);
    
    -- PORT A signals
    signal DOADO : std_logic_vector(15 downto 0);
    --signal DOPADOP : std_logic_vector(1 downto 0);
    signal ADDRARDADDR : std_logic_vector(13 downto 0);
    signal CLKARDCLK : std_logic;
    signal ENARDEN : std_logic;
    signal REGCEAREGCE : std_logic;
    signal RSTRAMARSTRAM : std_logic;
    signal RSTREGARSTREG : std_logic;
    signal WEA : std_logic_vector(1 downto 0);
    signal DIADI : std_logic_vector(15 downto 0);
    signal DIPADIP : std_logic_vector(1 downto 0);
    
    -- Port B signals
    --signal DOBDO : std_logic_vector(15 downto 0);
    --signal DOPBDOP : std_logic_vector(1 downto 0);
    signal ADDRBWRADDR : std_logic_vector(13 downto 0);
    signal CLKBWRCLK : std_logic;
    signal ENBWREN : std_logic;
    signal REGCEB : std_logic;
    signal RSTRAMB : std_logic;
    signal RSTREGB : std_logic;
    signal WEBWE : std_logic_vector(3 downto 0);
    signal DIBDI : std_logic_vector(15 downto 0);
    signal DIPBDIP : std_logic_vector(1 downto 0);
    
    attribute LOC:string;
    attribute LOC of RAMB18E1_i: label is "RAMB18_X3Y25";
    
begin
    
    -- RAMB18E1: 18K-bit Configurable Synchronous Block RAM 7 Series
    RAMB18E1_i: RAMB18E1
        generic map(
             -- Address Collision Mode: "PERFORMANCE" or "DELAYED_WRITE"
             RDADDR_COLLISION_HWCONFIG => "DELAYED_WRITE",
             -- Collision check: Values ("ALL", "WARNING_ONLY", "GENERATE_X_ONLY" or "NONE")
             SIM_COLLISION_CHECK => "ALL",
            -- DOA_REG, DOB_REG: Optional output register (0 or 1)
            DOA_REG => 0,
            DOB_REG => 0,
            -- INITP_00 to INITP_07: Initial contents of parity memory array
            INITP_00 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INITP_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INITP_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INITP_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INITP_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INITP_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INITP_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INITP_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
            -- INIT_00 to INIT_3F: Initial contents of data memory array
            INIT_00 => X"DEADBEEF00000000000000000000000000000000000000000000000000000000",
            INIT_01 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_02 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_03 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_04 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_05 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_06 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_07 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_08 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_09 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0A => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0B => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0C => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0D => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0E => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_0F => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_10 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_11 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_12 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_13 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_14 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_15 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_16 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_17 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_18 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_19 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1A => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1B => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1C => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1D => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1E => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1F => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_20 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_21 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_22 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_23 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_24 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_25 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_26 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_27 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_28 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_29 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2A => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2B => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2C => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2D => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2E => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_2F => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_30 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_31 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_32 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_33 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_34 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_35 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_36 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_37 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_38 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_39 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3A => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3B => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3C => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3D => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3E => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_3F => X"0000000000000000000000000000000000000000000000000000000000000000",

            -- INIT_A, INIT_B: Initial values on output ports
            INIT_A => X"00000",
            INIT_B => X"00000",
            -- Initialization File: RAM initialization file
            INIT_FILE => "NONE",
            -- RAM Mode: "SDP" or "TDP"
            RAM_MODE => "SDP",
             -- READ_WIDTH_A/B, WRITE_WIDTH_A/B: Read/write width per port
             READ_WIDTH_A => 18, -- 0-72
             READ_WIDTH_B => 0, -- 0-18, not used in SPD mode
             WRITE_WIDTH_A => 0, -- 0-18, not used in SPD mode
             WRITE_WIDTH_B => 0, -- 0-72
             -- RSTREG_PRIORITY_A, RSTREG_PRIORITY_B: Reset or enable priority ("RSTREG" or "REGCE")
             RSTREG_PRIORITY_A => "RSTREG",
             RSTREG_PRIORITY_B => "RSTREG",
             -- SRVAL_A, SRVAL_B: Set/reset value for output
             SRVAL_A => X"00000",
             SRVAL_B => X"00000",
             -- Simulation Device: Must be set to "7SERIES" for simulation behaviour
             SIM_DEVICE => "7SERIES",
             -- WriteMode: Value on output upon a write ("WRITE_FIRST", "READ_FIRST", or "NO_CHANGE")
             WRITE_MODE_A => "WRITE_FIRST",
             WRITE_MODE_B => "WRITE_FIRST"
            )
        port map (
             -- Port A Data: 16-bit (each) output: Port A data
             DOADO => DOADO, -- 16-bit output: A port data/LSB data
             DOPADOP => open, -- 2-bit output: A port parity/LSB parity
             -- Port B Data: 16-bit (each) output: Port B data
             DOBDO => open, -- 16-bit output: B port data/MSB data
             DOPBDOP => open, -- 2-bit output: B port parity/MSB parity
             -- Port A Address/Control Signals: 14-bit (each) input: Port A address and control signals (read port
             -- when RAM_MODE="SDP")
             ADDRARDADDR => ADDRARDADDR, -- 14-bit input: A port address/Read address
             CLKARDCLK => CLKARDCLK, -- 1-bit input: A port clock/Read clock
             ENARDEN => ENARDEN, -- 1-bit input: A port enable/Read enable
             REGCEAREGCE => REGCEAREGCE, -- 1-bit input: A port register enable/Register enable
             RSTRAMARSTRAM => RSTRAMARSTRAM, -- 1-bit input: A port set/reset
             RSTREGARSTREG => RSTREGARSTREG, -- 1-bit input: A port register set/reset
             WEA => WEA, -- 2-bit input: A port write enable
             -- Port A Data: 16-bit (each) input: Port A data
             DIADI => DIADI, -- 16-bit input: A port data/LSB data
             DIPADIP => DIPADIP, -- 2-bit input: A port parity/LSB parity
             -- Port B Address/Control Signals: 14-bit (each) input: Port B address and control signals (write port
             -- when RAM_MODE="SDP")
             ADDRBWRADDR => ADDRBWRADDR, -- 14-bit input: B port address/Write address
             CLKBWRCLK => CLKBWRCLK, -- 1-bit input: B port clock/Write clock
             ENBWREN => ENBWREN, -- 1-bit input: B port enable/Write enable
             REGCEB => REGCEB, -- 1-bit input: B port register enable
             RSTRAMB => RSTRAMB, -- 1-bit input: B port set/reset
             RSTREGB => RSTREGB, -- 1-bit input: B port register set/reset
             WEBWE => WEBWE, -- 4-bit input: B port write enable/Write enable
             -- Port B Data: 16-bit (each) input: Port B data
             DIBDI => DIBDI, -- 16-bit input: B port data/MSB data
             DIPBDIP => DIPBDIP -- 2-bit input: B port parity/MSB parity
            );
            
            
    -- Port A
    ADDRARDADDR <= "0000" & address & "0000" when n_rst = '1' else (others=>'0');
    CLKARDCLK <= clk;
    tmp_data <= DOADO;
    ENARDEN <= '1';
    REGCEAREGCE <= '0';
    RSTRAMARSTRAM <= '0';
    RSTREGARSTREG <= '0';
    WEA <= (others=>'0');
    DIADI <= (others=>'0');
    DIPADIP <= (others=>'0');
    
    -- Port B
    ADDRBWRADDR <= (others=>'0');
    CLKBWRCLK <= '0';
    ENBWREN <= '0';
    REGCEB <= '0';
    RSTRAMB <= '0';
    RSTREGB <= '0';
    WEBWE <= (others=>'0');
    DIBDI <= (others=>'0');
    DIPBDIP <= (others=>'0');

    mem_data <= tmp_data(12 downto 0);
    
end architecture;