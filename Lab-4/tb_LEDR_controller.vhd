library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_LEDR_controller is
begin
end;

architecture Simulation of tb_LEDR_controller is

  component LEDR_controller is
    port(clk      : in  std_logic;
         reset_n  : in  std_logic;
         distance : in  unsigned(12 downto 0);
         Y        : out std_logic);
  end component;

  signal clk      : std_logic := '0';
  signal reset_n  : std_logic := '0';
  signal distance : unsigned(12 downto 0);
  signal LEDR_val : std_logic;

  signal TbSimEnded   : std_logic := '0';
  constant TbPeriod   : time      := 20 ns;
  -- This is the size of the PWM counter inside the LEDR controller.
  constant CntWidth   : integer   := 8;
  -- This is how many PWM counter periods we want to see.
  constant CntPeriods : integer   := 2;

  constant WaitTime : time := TbPeriod * (2**CntWidth) * CntPeriods;

begin

  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

  dut : LEDR_controller
    port map(clk      => clk,
             reset_n  => reset_n,
             distance => distance,
             Y        => LEDR_val);

  process
  begin
    wait for TbPeriod;
    reset_n <= '1';
    wait for TbPeriod;

    -- What we expect to see here: For small values of distance, LEDR should
    -- have a very high duty cycle, with a smaller duty cycle as distance gets
    -- larger. Once distance > 4000, the duty cycle should be zero.
    for itr in 0 to 5000 loop
      distance <= to_unsigned(itr, distance'length);
      wait for WaitTime;
    end loop;

    TbSimEnded <= '1';
    wait;

  end process;
end;

