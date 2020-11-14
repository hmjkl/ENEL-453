library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity datapath is
  port(clk      : in  std_logic;
       SW       : in  std_logic_vector(9 downto 0);
       reset_n  : in  std_logic;
       freeze_n : in  std_logic;
       HEX0     : out std_logic_vector(7 downto 0);
       HEX1     : out std_logic_vector(7 downto 0);
       HEX2     : out std_logic_vector(7 downto 0);
       HEX3     : out std_logic_vector(7 downto 0);
       HEX4     : out std_logic_vector(7 downto 0);
       HEX5     : out std_logic_vector (7 downto 0));
end;

architecture Behavioral of datapath is

  component ADC_Data is
    port(clk      : in  std_logic;
         reset_n  : in  std_logic;      -- active-low
         voltage  : out std_logic_vector(12 downto 0);
         distance : out std_logic_vector(12 downto 0);
         ADC_raw  : out std_logic_vector(11 downto 0);
         ADC_out  : out std_logic_vector(11 downto 0));
  end component;

  signal voltage  : std_logic_vector(12 downto 0);
  signal distance : std_logic_vector(12 downto 0);
  signal ADC_raw  : std_logic_vector(11 downto 0);
  signal ADC_out  : std_logic_vector(11 downto 0);

  component mux4 is
    generic(sz : integer := 1);
    port(d0 : in  std_logic_vector(sz - 1 downto 0);
         d1 : in  std_logic_vector(sz - 1 downto 0);
         d2 : in  std_logic_vector(sz - 1 downto 0);
         d3 : in  std_logic_vector(sz - 1 downto 0);
         s  : in  std_logic_vector(1 downto 0);
         y  : out std_logic_vector(sz - 1 downto 0));
  end component;

  signal d0 : std_logic_vector(15 downto 0);
  signal d1 : std_logic_vector(15 downto 0);
  signal d2 : std_logic_vector(15 downto 0);
  signal d3 : std_logic_vector(15 downto 0);
  signal y  : std_logic_vector(15 downto 0);

  signal d0_data            : std_logic_vector(6 downto 0);
  signal d1_data            : std_logic_vector(6 downto 0);
  signal d2_data            : std_logic_vector(6 downto 0);
  signal d3_data            : std_logic_vector(6 downto 0);
  signal y_aux_data         : std_logic_vector(6 downto 0);
  signal seven_segment_conf : std_logic_vector(6 downto 0);


  component SevenSegment is
    port(DP_in     : in  std_logic_vector(5 downto 0);
         Blank     : in  std_logic_vector (5 downto 0);
         AutoBlank : in  std_logic;
         Num_Hex0  : in  std_logic_vector(3 downto 0);
         Num_Hex1  : in  std_logic_vector(3 downto 0);
         Num_Hex2  : in  std_logic_vector(3 downto 0);
         Num_Hex3  : in  std_logic_vector(3 downto 0);
         Num_Hex4  : in  std_logic_vector(3 downto 0);
         Num_Hex5  : in  std_logic_vector(3 downto 0);
         HEX0      : out std_logic_vector(7 downto 0);
         HEX1      : out std_logic_vector(7 downto 0);
         HEX2      : out std_logic_vector(7 downto 0);
         HEX3      : out std_logic_vector(7 downto 0);
         HEX4      : out std_logic_vector(7 downto 0);
         HEX5      : out std_logic_vector (7 downto 0));
  end component;

  signal DP_in    : std_logic_vector(5 downto 0) := (others => '0');
  signal Blank    : std_logic_vector(5 downto 0);
  signal num_Hex0 : std_logic_vector(3 downto 0);
  signal num_Hex1 : std_logic_vector(3 downto 0);
  signal num_Hex2 : std_logic_vector(3 downto 0);
  signal num_Hex3 : std_logic_vector(3 downto 0);
  signal num_Hex4 : std_logic_vector(3 downto 0);
  signal num_Hex5 : std_logic_vector(3 downto 0);

  component DFlip is
    generic(sz : integer := 1);
    port(clk     : in  std_logic;
         en      : in  std_logic;
         reset_n : in  std_logic;
         D       : in  std_logic_vector(sz - 1 downto 0);
         Q       : out std_logic_vector(sz -1 downto 0));
  end component;

  signal hex_ins : std_logic_vector(15 downto 0);

  component binary_bcd is
    port(clk     : in  std_logic;
         reset_n : in  std_logic;
         binary  : in  std_logic_vector(12 downto 0);
         bcd     : out std_logic_vector(15 downto 0));
  end component;

  signal voltage_bcd  : std_logic_vector(15 downto 0);
  signal distance_bcd : std_logic_vector(15 downto 0);
  signal sw_bcd       : std_logic_vector(15 downto 0);

begin

  i_ADC_data_1 : ADC_Data
    port map(clk      => clk,
             reset_n  => reset_n,
             voltage  => voltage,
             distance => distance,
             ADC_raw  => ADC_raw,
             ADC_out  => ADC_out);

  i_binary_bcd_1 : binary_bcd
    port map(clk     => clk,
             reset_n => reset_n,
             binary  => voltage,
             bcd     => voltage_bcd);

  i_binary_bcd_2 : binary_bcd
    port map(clk     => clk,
             reset_n => reset_n,
             binary  => distance,
             bcd     => distance_bcd);

  d0 <= "000000" & SW;
  d1 <= distance_bcd;
  d2 <= voltage_bcd;
  d3 <= "0000" & ADC_out;

  i_mux4_1 : mux4
    generic map(sz => 16)
    port map(d0 => d0,
             d1 => d1,
             d2 => d2,
             d3 => d3,
             s  => SW(9 downto 8),
             y  => y);

  i_DFlip_1 : DFlip
    generic map(sz => 16)
    port map(clk     => clk,
             en      => freeze_n,
             reset_n => reset_n,
             D       => y,
             Q       => hex_ins);


  Num_Hex0 <= hex_ins(3 downto 0);
  Num_Hex1 <= hex_ins(7 downto 4);
  Num_Hex2 <= hex_ins(11 downto 8);
  Num_Hex3 <= hex_ins(15 downto 12);
  Num_Hex4 <= (others => '0');
  Num_Hex5 <= (others => '0');



-- mux for selecting DP and autoblank for the seven segment.
-- input pattern of: {DP_in,AutoBlank}.
-- @FIXME: better naming

  d0_data <= "0000000";
  d1_data <= "0001001";
  d2_data <= "0010001";
  d3_data <= "0000001";

  i_mux4_2 : mux4
    generic map(sz => 7)
    port map(d0 => d0_data,
             d1 => d1_data,
             d2 => d2_data,
             d3 => d3_data,
             s  => SW(9 downto 8),
             y  => y_aux_data);


  i_DFlip_2 : DFlip
    generic map(sz => 7)
    port map(clk     => clk,
             en      => freeze_n,
             reset_n => reset_n,
             D       => y_aux_data,
             Q       => seven_segment_conf);


  blank <= "110000";
  DP_in <= seven_segment_conf(6 downto 1);

  i_SevenSegment_1 : SevenSegment
    port map(DP_in     => DP_in,
             Blank     => Blank,
             AutoBlank => seven_segment_conf(0),
             Num_Hex0  => num_Hex0,
             Num_Hex1  => num_Hex1,
             Num_Hex2  => num_Hex2,
             Num_Hex3  => num_Hex3,
             Num_Hex4  => num_Hex4,
             Num_Hex5  => num_Hex5,
             HEX0      => HEX0,
             HEX1      => HEX1,
             HEX2      => HEX2,
             HEX3      => HEX3,
             HEX4      => HEX4,
             HEX5      => HEX5);

end;
