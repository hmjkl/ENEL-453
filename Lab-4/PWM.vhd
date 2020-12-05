library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PWM is
  generic (sz : integer := 32);
  port (clk        : in  std_logic;
        reset_n    : in  std_logic;
        en         : in  std_logic;
        duty_cycle : in  unsigned(sz - 1 downto 0);
        y          : out std_logic;
        y_inv      : out std_logic);
end;

architecture Behavioral of PWM is

  signal cnt   : unsigned(sz - 1 downto 0);
  signal y_tmp : std_logic;

begin

  seq : process(clk, reset_n)
  begin
    if reset_n = '0' then
      cnt <= (others => '0');
    elsif rising_edge(clk) and en = '1' then
      cnt <= cnt + 1;
    end if;
  end process;

  comb : process(duty_cycle, cnt, y_tmp)
  begin
    if duty_cycle > cnt then
      y_tmp <= '1';
    else
      y_tmp <= '0';
    end if;

    y     <= y_tmp;
    y_inv <= not y_tmp;

  end process;

end;
