library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LEDR_controller is
  port(clk      : in  std_logic;
       reset_n  : in  std_logic;
       distance : in  unsigned(12 downto 0);
       Y        : out std_logic);
end;

architecture Structural of LEDR_controller is

  component mapper is
    generic(cond : integer := 777);
    port(distance : in  unsigned(12 downto 0);
         d0       : in  std_logic;
         d1       : in  std_logic;
         Y        : out std_logic);
  end component;

  component distance2duty is
    port(distance       : in  unsigned(12 downto 0);
         distance_trunc : out unsigned(7 downto 0));
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

  signal distance_trunc : unsigned(7 downto 0);
  signal PWM_LEDR       : std_logic;


begin

  i_distance2duty : distance2duty
    port map(distance       => distance,
             distance_trunc => distance_trunc);

  i_PWM_1 : PWM
    generic map(sz => 8)
    port map(clk        => clk,
             reset_n    => reset_n,
             en         => '1',
             duty_cycle => distance_trunc,
             y          => open,
             y_inv      => PWM_LEDR);

  i_mapper_1 : mapper
    generic map(cond => 4001)
    port map(distance => distance,
             d0       => '0',
             d1       => PWM_LEDR,
             Y        => Y);
end;
