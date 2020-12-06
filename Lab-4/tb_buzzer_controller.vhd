library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_buzzer_controller is
begin
end;

architecture Simulation of tb_buzzer_controller is

  component buzzer_controller is
    port(clk      : in  std_logic;
         reset_n  : in  std_logic;
         en       : in  std_logic;
         distance : in  unsigned(12 downto 0);
         buzzer   : out std_logic);
  end component;

  signal clk      : std_logic := '0';
  signal reset_n  : std_logic := '0';
  signal en       : std_logic := '1';
  signal distance : unsigned(12 downto 0);
  signal buzzer   : std_logic;

  signal TbSimEnded : std_logic := '0';
  constant TbPeriod : time      := 20 ns;

  constant CntWidth : integer := 8;
  -- The biggest number to wait for inside the internal counter of the
  -- controller. This should be around 600
  constant CntMax   : integer := 600;
                               -- This is how many PWM counter periods we want to see.
constant CntPeriods : integer := 1;

  constant WaitTime : time := TbPeriod * (2**CntWidth) * CntMax * CntPeriods;


begin

  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

  dut : buzzer_controller
    port map(clk      => clk,
             reset_n  => reset_n,
             en       => en,
             distance => distance,
             buzzer   => buzzer);

  process
  begin
    wait for TbPeriod;
    reset_n <= '1';
    wait for TbPeriod;

    -- What we expect to see: Ther period of the wave should increase as the
    -- distances increases. From our results, f(3.50cm) = 5005Hz, and
    -- f(40.95cm) = 250Hz

    for itr in 30 to 500 loop
      distance <= to_unsigned(10*itr, distance'length);
      wait for WaitTime;
    end loop;

    TbSimEnded <= '1';
    wait;
  end process;

end;
