
library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

  component top_level
    port (clk     : in std_logic;
          reset_n : in std_logic;
          SW      : in std_logic_vector (9 downto 0);
          LEDR    : out std_logic_vector (9 downto 0);
          HEX0    : out std_logic_vector (7 downto 0);
          HEX1    : out std_logic_vector (7 downto 0);
          HEX2    : out std_logic_vector (7 downto 0);
          HEX3    : out std_logic_vector (7 downto 0);
          HEX4    : out std_logic_vector (7 downto 0);
          HEX5    : out std_logic_vector (7 downto 0));
  end component;

  signal clk     : std_logic;
  signal reset_n : std_logic;
  signal SW      : std_logic_vector (9 downto 0);
  signal LEDR    : std_logic_vector (9 downto 0);
  signal HEX0    : std_logic_vector (7 downto 0);
  signal HEX1    : std_logic_vector (7 downto 0);
  signal HEX2    : std_logic_vector (7 downto 0);
  signal HEX3    : std_logic_vector (7 downto 0);
  signal HEX4    : std_logic_vector (7 downto 0);
  signal HEX5    : std_logic_vector (7 downto 0);

  -- modified seven segment values (include dp = 0)
  constant H0 : STD_LOGIC_VECTOR(7 downto 0) := "00111111";
  constant H1 : STD_LOGIC_VECTOR(7 downto 0) := "00000110";
  constant H2 : STD_LOGIC_VECTOR(7 downto 0) := "01011011";
  constant H3 : STD_LOGIC_VECTOR(7 downto 0) := "01001111";
  constant H4 : STD_LOGIC_VECTOR(7 downto 0) := "01100110";
  constant H5 : STD_LOGIC_VECTOR(7 downto 0) := "01101101";
  constant H6 : STD_LOGIC_VECTOR(7 downto 0) := "01111101";
  constant H7 : STD_LOGIC_VECTOR(7 downto 0) := "00000111";
  constant H8 : STD_LOGIC_VECTOR(7 downto 0) := "01111111";
  constant H9 : STD_LOGIC_VECTOR(7 downto 0) := "01100111";
  constant Ha : STD_LOGIC_VECTOR(7 downto 0) := "01110111";
  constant Hb : STD_LOGIC_VECTOR(7 downto 0) := "01111100";
  constant Hc : STD_LOGIC_VECTOR(7 downto 0) := "00111001";
  constant Hd : STD_LOGIC_VECTOR(7 downto 0) := "01011110";
  constant He : STD_LOGIC_VECTOR(7 downto 0) := "01111001";
  constant Hf : STD_LOGIC_VECTOR(7 downto 0) := "01110001";


  constant TbPeriod : time := 20 ns;
  signal TbClock : std_logic := '0';
  signal TbSimEnded : std_logic := '0';

begin

  dut : top_level
    port map (clk     => clk,
              reset_n => reset_n,
              SW      => SW,
              LEDR    => LEDR,
              HEX0    => HEX0,
              HEX1    => HEX1,
              HEX2    => HEX2,
              HEX3    => HEX3,
              HEX4    => HEX4,
              HEX5    => HEX5);

  -- Clock generation
  TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
  clk <= TbClock;

  stimuli : process
  begin
    SW <= (others => '0');

    -- Toggle reset
    reset_n <= '0';
    wait for 10 ns;
    reset_n <= '1';
    wait for 10 ns;

    -- reset was just zero (on), so our output should be zeros

    assert HEX0 = (not H0) report "Test 0 (0x0, Reset) failed (0)";
    assert HEX1 = (not H0) report "Test 0 (0x0, Reset) failed (1)";
    assert HEX2 = (not H0) report "Test 0 (0x0, Reset) failed (2)";
    assert HEX3 = (not H0) report "Test 0 (0x0, Reset) failed (3)";

    
    wait for 200*TbPeriod;
    
    -- input is zeros, show bcd should be all zero after fsm completes
    -- calculations.
    assert HEX0 = (not H0) report "Test 1 (0x0, Decimal) failed (0)";
    assert HEX1 = (not H0) report "Test 1 (0x0, Decimal) failed (1)";
    assert HEX2 = (not H0) report "Test 1 (0x0, Decimal) failed (2)";
    assert HEX3 = (not H0) report "Test 1 (0x0, Decimal) failed (3)";
    
    SW <= 10X"7";
    -- Worst case it takes around 120 cycles to update bcd. Add a few
    -- extra to make reading easier...
    wait for 200*TbPeriod;

    assert HEX0 = (not H7) report "Test 2 (0x7, Decimal) failed (0)";
    assert HEX1 = (not H0) report "Test 2 (0x7, Decimal) failed (1)";
    assert HEX2 = (not H0) report "Test 2 (0x7, Decimal) failed (2)";
    assert HEX3 = (not H0) report "Test 2 (0x7, Decimal) failed (3)";

    SW<=10d"23";

    wait for 200*TbPeriod;

    assert HEX0 = (not H3) report "Test 3 (0d23, Decimal) failed (0)";
    assert HEX1 = (not H2) report "Test 3 (0d23, Decimal) failed (1)";
    assert HEX2 = (not H0) report "Test 3 (0d23, Decimal) failed (2)";
    assert HEX3 = (not H0) report "Test 3 (0d23, Decimal) failed (3)";

    SW(9) <= '1';

    -- wait for a while to make reading easier
    wait for 50*TbPeriod;
    
    assert HEX0 = (not H7) report "Test 4 (0d23, Hex) failed (0)";
    assert HEX1 = (not H1) report "Test 4 (0d23, Hex) failed (1)";
    assert HEX2 = (not H0) report "Test 4 (0d23, Hex) failed (2)";
    assert HEX3 = (not H0) report "Test 4 (0d23, Hex) failed (3)";

    wait for 50*TbPeriod;

    SW <= 10d"255";
    SW(9) <= '0';

    wait for 200*TbPeriod;

    assert HEX0 = (not H5) report "Test 5 (0d255, Decimal) failed (0)";
    assert HEX1 = (not H5) report "Test 5 (0d255, Decimal) failed (1)";
    assert HEX2 = (not H2) report "Test 5 (0d255, Decimal) failed (2)";
    assert HEX3 = (not H0) report "Test 5 (0d255, Decimal) failed (3)";

    SW(9) <= '1';

    wait for 50*TbPeriod;

    assert HEX0 = (not Hf) report "Test 5 (0d255, Hex) failed (0)";
    assert HEX1 = (not Hf) report "Test 5 (0d255, Hex) failed (1)";
    assert HEX2 = (not H0) report "Test 5 (0d255, Hex) failed (2)";
    assert HEX3 = (not H0) report "Test 5 (0d255, Hex) failed (3)";

    wait for 50*TbPeriod;

    reset_n <='0'; -- Nothing should happend to the output (reset
                   -- shouldn't affect the mux)

    wait for 50*TbPeriod;

    assert HEX0 = (not Hf) report "Test 6 (0d255, Hex) failed (0)";
    assert HEX1 = (not Hf) report "Test 6 (0d255, Hex) failed (1)";
    assert HEX2 = (not H0) report "Test 6 (0d255, Hex) failed (2)";
    assert HEX3 = (not H0) report "Test 6 (0d255, Hex) failed (3)";

    SW(9) <= '0';

    wait for 50*TbPeriod;

    -- reset low and in bcd mode, so bcd should be zeros
    assert HEX0 = (not H0) report "Test 7 (0d255, Reset) failed (0)";
    assert HEX1 = (not H0) report "Test 7 (0d255, Reset) failed (1)";
    assert HEX2 = (not H0) report "Test 7 (0d255, Reset) failed (2)";
    assert HEX3 = (not H0) report "Test 7 (0d255, Reset) failed (3)";

    -- Stop the clock and hence terminate the simulation
    TbSimEnded <= '1';
    wait;
  end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_top_level of tb_top_level is
  for tb
  end for;
end cfg_tb_top_level;
