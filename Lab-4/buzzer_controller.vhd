library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is a controller for the buzzer. It is more or less structural code to
-- make viewing and editing easier.

entity buzzer_controller is
  port(clk      : in  std_logic;
       reset_n  : in  std_logic;
       en       : in  std_logic;
       distance : in  unsigned(12 downto 0);
       buzzer   : out std_logic);
end;

architecture Behavioral of buzzer_controller is

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

  signal PWM_EN         : std_logic;
  signal buzzer_max_cnt : integer range 0 to 8191;

begin

  process(clk)
  begin
    if rising_edge(clk) then
      -- This is a fast approximation of a function that results in
      -- freq(3.50cm) = 5000 and freq(40.95cm) = 350.
      buzzer_max_cnt <= to_integer((distance srl 2) - 10);
    end if;
  end process;

  i_counter_1 : counter
    generic map(CLK_DIV_SCALE => 8191)
    port map(clk     => clk,
             reset_n => reset_n,
             max_cnt => buzzer_max_cnt,
             en      => '1',
             Y       => PWM_EN);

  i_PWM_1 : PWM
    generic map(sz => 8)
    port map(clk        => clk,
             reset_n    => reset_n,
             en         => PWM_EN,
             duty_cycle => X"7F",
             y          => open,
             y_inv      => buzzer);

end;

