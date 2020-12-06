library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_PWM is
begin
end;

architecture Simulation of tb_PWM is

  component PWM is
    generic (sz : integer := 32);
    port (clk        : in  std_logic;
          reset_n    : in  std_logic;
          en         : in  std_logic;
          duty_cycle : in  unsigned(sz - 1 downto 0);
          y          : out std_logic;
          y_inv      : out std_logic);
  end component;

  signal clk        : std_logic := '0';
  signal reset_n    : std_logic := '0';
  signal en         : std_logic;
  signal duty_cycle : unsigned(sz - 1 downto 0);
  signal y          : std_logic;
  signal y_inv      : std_logic;

begin

  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

  dut : PWM
    generic map(sz => 8)
    port map(clk        => clk,
             reset_n    => reset_n,
             en         => en,
             duty_cycle => duty_cycle,
             y          => y,
             y_inv      => y_inv);


end;
