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
    port(distance   : in  unsigned(12 downto 0);
         duty_cycle : out unsigned(7 downto 0));
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

  signal duty_cycle : unsigned(7 downto 0);
  signal PWM_LEDR   : std_logic;


begin

  -- Uncomment the following line for the quick non-linear brightness for LEDR
  --duty_cycle <= unsigned(distance(11 downto 4));

  -- This is an improved version that has linear steps in brightness.
  i_distance2duty : distance2duty
    port map(distance   => distance,
             duty_cycle => duty_cycle);


  i_PWM_1 : PWM
    generic map(sz => 8)
    port map(clk        => clk,
             reset_n    => reset_n,
             en         => '1',
             duty_cycle => duty_cycle,
             y          => open,
             y_inv      => PWM_LEDR);

  -- Only turns LEDs on for distance < 4000
  i_mapper_1 : mapper
    generic map(cond => 4001)
    port map(distance => distance,
             d0       => '0',
             d1       => PWM_LEDR,
             Y        => Y);
end;
