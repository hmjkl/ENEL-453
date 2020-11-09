library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity ADC_Data is
  port(clk      : in  std_logic;
       reset_n  : in  std_logic;        -- active-low
       voltage  : out std_logic_vector (12 downto 0);  -- Voltage in milli-volts
       distance : out std_logic_vector (12 downto 0);  -- distance in 10^-4 cm (e.g. if distance = 33 cm, then 3300 is the value)
       ADC_raw  : out std_logic_vector (11 downto 0);  -- the latest 12-bit ADC value
       ADC_out  : out std_logic_vector (11 downto 0)  -- moving average of ADC value, over 256 samples,
       );  -- number of samples defined by the averager module
end ADC_Data;

architecture rtl of ADC_Data is

  constant X : integer := 4;  -- 4; -- X = log4(2**N), e.g. log4(2**8) = log4(4**4) = log4(256) = 4 (bits of resolution gained)

  signal response_valid_out        : std_logic;
  signal ADC_raw_temp, ADC_out_ave : std_logic_vector(11 downto 0);
  signal voltage_temp              : std_logic_vector(12 downto 0);
  signal temp                      : std_logic_vector(11 downto 0);
  signal Q_high_res                : std_logic_vector(X+11 downto 0);  -- (4+11 DOWNTO 0); -- first add (i.e. X) is log4(2**N), e.g. log4(2**8) = log4(256) = 4, must match X constant

  component ADC_Conversion_wrapper is  -- this brings in the ADC module, either as a hardware peripheral or as a simulation model
    port(MAX10_CLK1_50      : in  std_logic;
         response_valid_out : out std_logic;
         ADC_out            : out std_logic_vector (11 downto 0)
         );
  end component;
--******************************************************************************************************************************************
-- Comment out one of the two lines below, to select whether you want RTL (for DE10-Lite board) or simulation (for testbench) for the ADC **
--******************************************************************************************************************************************
  for ADC_ins : ADC_Conversion_wrapper use entity work.ADC_Conversion_wrapper(RTL);  -- selects the RTL architecture
--for ADC_ins : ADC_Conversion_wrapper use entity work.ADC_Conversion_wrapper(simulation); -- selects the simulation architecture
--******************************************************************************************************************************************

  component voltage2distance_array2 is  -- converts ADC's voltage value to distance value
    port(  -- according to Sharp GP2Y0A41SK0F Distance Sensor datasheet
      clk      : in  std_logic;
      reset_n  : in  std_logic;
      voltage  : in  std_logic_vector(12 downto 0);
      distance : out std_logic_vector(12 downto 0)
      );
  end component;

  component averager256 is  -- calculates moving average of 256 12-bit samples
    generic(
      N    : integer;
      X    : integer;
      bits : integer);
    port (
      clk     : in  std_logic;
      EN      : in  std_logic;  -- takes a new sample when high for each clock cycle
      reset_n : in  std_logic;          -- active-low
      Din     : in  std_logic_vector(bits downto 0);  -- input sample for moving average calculation
      Q       : out std_logic_vector(bits downto 0)  -- 12-bit moving average of 256 samples
      );
  end component;


begin

  voltage2distance_ins : voltage2distance_array2
    port map(
      clk      => clk,
      reset_n  => reset_n,
      voltage  => voltage_temp,
      distance => distance
      );

  ADC_ins : ADC_Conversion_wrapper port map(
    MAX10_CLK1_50      => clk,
    response_valid_out => response_valid_out,
    ADC_out            => ADC_raw_temp  -- normally ADC_out_temp
    );

  averager : averager256 generic map(  -- change here to modify the number of samples to average
    N    => 8,  -- 8, 10, -- log2(number of samples to average over), e.g. N=8 is 2**8 = 256 samples
    X    => 4,  -- 4, 5, -- X = log4(2**N), e.g. log4(2**8) = log4(4**4) = log4(256) = 4 (bit of resolution gained)
    bits => 11)  -- 11 -- number of bits in the input data to be averaged
    port map(
      clk     => clk,
      EN      => response_valid_out,
      reset_n => reset_n,
      Din     => ADC_raw_temp,
      Q       => ADC_out_ave
      );


  -- Here we do not append a zero so that the voltage output can range from 0
  -- -> 5000.
  voltage_temp <= std_logic_vector(resize(unsigned(ADC_out_ave)*2500*2/(2**12), voltage_temp'length));  -- Converting ADC_out_ave, a 12-bit binary value, to voltage value (in mV), using type conversions

  process(clk)
  begin
    if rising_edge(clk) then
      ADC_out <= ADC_out_ave;
      ADC_raw <= ADC_raw_temp;
      voltage <= voltage_temp;
    end if;
  end process;
end rtl;
