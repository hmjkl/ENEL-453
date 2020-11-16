library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
begin
end;

architecture tb of tb_top_level is

  component top_level is
    port(clk      : in  std_logic;
         SW       : in  std_logic_vector(9 downto 0);
         reset_n  : in  std_logic;
         freeze_n : in  std_logic;
         LEDR     : out std_logic_vector(9 downto 0);
         HEX0     : out std_logic_vector(7 downto 0);
         HEX1     : out std_logic_vector(7 downto 0);
         HEX2     : out std_logic_vector(7 downto 0);
         HEX3     : out std_logic_vector(7 downto 0);
         HEX4     : out std_logic_vector(7 downto 0);
         HEX5     : out std_logic_vector(7 downto 0));
  end component;

  signal clk      : std_logic := '0';
  signal SW       : std_logic_vector(9 downto 0);
  signal reset_n  : std_logic;
  signal freeze_n : std_logic;
  signal LEDR     : std_logic_vector(9 downto 0);
  signal HEX0     : std_logic_vector(7 downto 0);
  signal HEX1     : std_logic_vector(7 downto 0);
  signal HEX2     : std_logic_vector(7 downto 0);
  signal HEX3     : std_logic_vector(7 downto 0);
  signal HEX4     : std_logic_vector(7 downto 0);
  signal HEX5     : std_logic_vector(7 downto 0);

  constant tbperiod : time      := 20 ns;
  -- We need a very long wait time because of debounce.
  constant dt       : time      := 31 ms;
  -- Shorter wait time used for non-critical times and used to make
  -- viewing easier.
  constant smalltime : time      := 2.5 ms;
  signal TbSimEnded : std_logic := '0';

  -- constants that will help find the expected HEX output
  constant H0    : std_logic_vector(7 downto 0) := "00111111";
  constant H1    : std_logic_vector(7 downto 0) := "00000110";
  constant H2    : std_logic_vector(7 downto 0) := "01011011";
  constant H3    : std_logic_vector(7 downto 0) := "01001111";
  constant H4    : std_logic_vector(7 downto 0) := "01100110";
  constant H5    : std_logic_vector(7 downto 0) := "01101101";
  constant H6    : std_logic_vector(7 downto 0) := "01111101";
  constant H7    : std_logic_vector(7 downto 0) := "00000111";
  constant H8    : std_logic_vector(7 downto 0) := "01111111";
  constant H9    : std_logic_vector(7 downto 0) := "01100111";
  constant Ha    : std_logic_vector(7 downto 0) := "01110111";
  constant Hb    : std_logic_vector(7 downto 0) := "01111100";
  constant Hc    : std_logic_vector(7 downto 0) := "00111001";
  constant Hd    : std_logic_vector(7 downto 0) := "01011110";
  constant He    : std_logic_vector(7 downto 0) := "01111001";
  constant Hf    : std_logic_vector(7 downto 0) := "01110001";
  constant DP    : std_logic_vector(7 downto 0) := "10000000";
  constant BLANK : std_logic_vector(7 downto 0) := "00000000";

  signal HEX0_expected : std_logic_vector(7 downto 0);
  signal HEX1_expected : std_logic_vector(7 downto 0);
  signal HEX2_expected : std_logic_vector(7 downto 0);
  signal HEX3_expected : std_logic_vector(7 downto 0);
  signal HEX4_expected : std_logic_vector(7 downto 0);
  signal HEX5_expected : std_logic_vector(7 downto 0);


begin

  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

  dut : top_level
    port map(clk      => clk,
             SW       => SW,
             reset_n  => reset_n,
             freeze_n => freeze_n,
             LEDR     => LEDR,
             HEX0     => HEX0,
             HEX1     => HEX1,
             HEX2     => HEX2,
             HEX3     => HEX3,
             HEX4     => HEX4,
             HEX5     => HEX5);

  process
  begin
    -- TESTING RESET BEHAVIOR
    reset_n  <= '0';
    SW       <= (0 => '1', 1 => '1', others => '0');
    freeze_n <= '1';
    HEX0_expected <= (not H0);
    HEX1_expected <= (not H0);
    HEX2_expected <= (not H0);
    HEX3_expected <= (not H0);
    HEX4_expected <= (not blank);
    HEX5_expected <= (not blank);
    wait for smalltime;
        assert HEX0_expected = HEX0 report "Failed display reset test (HEX0)";
    assert HEX1_expected = HEX1 report "Failed display reset test (HEX1)";
    assert HEX2_expected = HEX2 report "Failed display reset test (HEX2)";
    assert HEX3_expected = HEX3 report "Failed display reset test (HEX3)";
    assert HEX4_expected = HEX4 report "Failed display reset test (HEX4)";
    assert HEX5_expected = HEX5 report "Failed display reset test (HEX5)";
    

    -- TESTING DISPLAY MODE 3 (HEX ADC VALUE)
    reset_n        <= '1';
    SW(9 downto 8) <= "11";
    wait for dt;

    -- Based on the averager test bench, the expected output value in would be
    -- 2242, so we will assert this. Using a hex calculator, we expect a value
    -- of 8c4 on the display. Not that we need to invert our signal
    -- because the segments turn on when the bits are zero.
    HEX0_expected <= (not H4);
    HEX1_expected <= (not Hc);
    HEX2_expected <= (not H8);
    HEX3_expected <= (not blank); -- AUTOBLANKING IS ENABLED FOR THIS MODE
    HEX4_expected <= (not blank);
    HEX5_expected <= (not blank);
    -- No need to check HEX4 and HEX5 after this point, as they are forced
    -- blank in datapath.vhd.
    wait for smalltime;
    assert HEX0_expected = HEX0 report "Failed display mode 3 test (HEX0)";
    assert HEX1_expected = HEX1 report "Failed display mode 3 test (HEX1)";
    assert HEX2_expected = HEX2 report "Failed display mode 3 test (HEX2)";
    assert HEX3_expected = HEX3 report "Failed display mode 3 test (HEX3)";
    assert HEX4_expected = HEX4 report "Failed display mode 3 test (HEX4)";
    assert HEX5_expected = HEX5 report "Failed display mode 3 test (HEX5)";

    -- TESTING DISPLAY MODE 2 (VOLTAGE IN DECIMAL)
    -- Now considering the hex value 8c4, the voltage output will be
    -- 0x8c4*5000/4096, which using a calculator comes to a decimal value of
    -- 2739.26 which will be floored, so we expect to see on our output 2739
    -- mv or 2739 V.
    
    SW(9 downto 8) <= "10";
    HEX0_expected <= (not H9);
    HEX1_expected <= (not H3);
    HEX2_expected <= (not H7);
    HEX3_expected <= not (H2 or DP); -- This should have a DP on it (hence the
                                     -- or)
    wait for smalltime;
    assert HEX0_expected = HEX0 report "Failed display mode 2 test (HEX0)";
    assert HEX1_expected = HEX1 report "Failed display mode 2 test (HEX1)";
    assert HEX2_expected = HEX2 report "Failed display mode 2 test (HEX2)";
    assert HEX3_expected = HEX3 report "Failed display mode 2 test (HEX3)";

    -- TESTING DISPLAY MODE 1 (DISTANCE IN CM)
    -- NOTE: This testbench will assume that you are using the default LUT,
    -- Using the LUT, a voltage of 2739mV should result, the distance in 10^-4
    -- is 414. so we expect an output of 4.14 on the screen
    SW(9 downto 8) <= "01";
    HEX0_expected <= (not H4);
    HEX1_expected <= (not H1);
    HEX2_expected <= not(DP or H4);
    HEX3_expected <= (not BLANK); -- AUTOBLANKING IS ENABLED FOR THIS MODE
    wait for smalltime;
    assert HEX0_expected = HEX0 report "Failed display mode 1 test (HEX0)";
    assert HEX1_expected = HEX1 report "Failed display mode 1 test (HEX1)";
    assert HEX2_expected = HEX2 report "Failed display mode 1 test (HEX2)";
    assert HEX3_expected = HEX3 report "Failed display mode 1 test (HEX3)";


    -- TESTING HOLD (DISPLAY SHOULD NOT CHANGE)
    freeze_n <= '0';
    wait for dt;
    SW(9 downto 8) <= "00";
    SW(7 downto 0) <= X"ED";
    wait for smalltime;
    assert HEX0_expected = HEX0 report "Failed display freeze (HEX0)";
    assert HEX1_expected = HEX1 report "Failed display freeze (HEX1)";
    assert HEX2_expected = HEX2 report "Failed display freeze (HEX2)";
    assert HEX3_expected = HEX3 report "Failed display freeze (HEX3)";

    -- TESTING HEX SWTICH DISPLAY MODE
    freeze_n <= '1';
    HEX0_expected <= (not Hd);
    HEX1_expected <= (not He);
    HEX2_expected <= (not H0);
    HEX3_expected <= (not H0); -- NO AUTO BLANKING IN THIS MODE
    wait for dt;
    assert HEX0_expected = HEX0 report "Failed hex mode (HEX0)";
    assert HEX1_expected = HEX1 report "Failed hex mode (HEX1)";
    assert HEX2_expected = HEX2 report "Failed hex mode (HEX2)";
    assert HEX3_expected = HEX3 report "Failed hex mode (HEX3)";


    TbSimEnded <= '1';
    assert false report "Simulation ended" severity failure;  -- need this line to halt the testbench  

  end process;

end;
