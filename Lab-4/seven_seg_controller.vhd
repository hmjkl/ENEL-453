library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is a controller for the sevensegment blinking. It is more or less structural code
-- to make viewing easier. It is basically the same as the buzzer controller,
-- but it has a longer fundemental freq.

entity seven_seg_controller is
  port(clk       : in  std_logic;
       reset_n   : in  std_logic;
       en        : in  std_logic;
       distance  : in  unsigned(12 downto 0);
       blank_val : out std_logic);
end;

architecture Behavioral of seven_seg_controller is

  component mapper is
    generic(cond : integer := 777);
    port(distance : in  unsigned(12 downto 0);
         d0       : in  std_logic;
         d1       : in  std_logic;
         Y        : out std_logic);
  end component;

  component counter is
    generic(CLK_DIV_SCALE : integer := 10_000);
    port(clk     : in  std_logic;
         reset_n : in  std_logic;
         en      : in  std_logic;
         max_cnt :     natural range 0 to CLK_DIV_SCALE;
         Y       : out std_logic);
  end component;

  component PWM is
    generic (sz : integer := 32);
    port (clk        : in  std_logic;
          reset_n    : in  std_logic;
          en         : in  std_logic;
          duty_cycle : in  unsigned(sz - 1 downto 0);
          y_inv      : out std_logic;
          y          : out std_logic);
  end component;

  signal PWM_EN            : std_logic;
  -- The size of seven_seg_max_cnt is given by seven_seg_max_cnt(8191), which
  -- is determined below.
  signal seven_seg_max_cnt : integer range 0 to 2047;
  signal blank_val_tmp     : std_logic;

begin

  process(clk)
  begin
    if rising_edge(clk) then
      -- This is a mostly arbitary function. It was chosen for being easy to
      -- make while providing a wide range of speeds for blinking.
      seven_seg_max_cnt <= to_integer((distance srl 2) - 10);
    end if;
  end process;

  i_counter_1 : counter
    generic map(CLK_DIV_SCALE => 2047)
    port map(clk     => clk,
             reset_n => reset_n,
             max_cnt => seven_seg_max_cnt,
             en      => '1',
             Y       => PWM_EN);

  -- The size of the PWM is picked somewhat arbitarly, But all that is needed
  -- is a semi-large fund. freq.
  i_PWM_1 : PWM
    generic map(sz => 16)
    port map(clk        => clk,
             reset_n    => reset_n,
             en         => PWM_EN,
             duty_cycle => X"8000",
             y          => open,
             y_inv      => blank_val_tmp);

  i_mapper_1 : mapper
    generic map(cond => 2001)
    port map(distance => distance,
             d0       => '0',
             d1       => blank_val_tmp,
             Y        => blank_val);

end;

