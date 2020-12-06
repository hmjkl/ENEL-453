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

      -- This is a fast approximate formula for buzzer_max_cnt that does not
      -- need multiplcation.
      --buzzer_max_cnt <= to_integer((distance srl 2) - 10);

      -- This is the slower buzzer_max_cnt formula. We know that F_out
      -- = F_o/counter, where F_o is given by 50E6/2^sz =
      -- 192KHz. Solving the equation at freq(3.50cm) = 5000 and
      -- freq(40.95cm) = 350 gives counter(d) = 0.163*d-18.13. 0.163
      -- ~= 42/256 hence the coeffs. The zero extend is needed to
      -- prevent overflows.
      buzzer_max_cnt <= to_integer(((42 * ("000000" & distance)) srl 8) - 18);
    end if;
  end process;

  i_counter_1 : counter
    generic map(CLK_DIV_SCALE => 8192)
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

