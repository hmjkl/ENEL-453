library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_counter is
begin
end;

architecture Simulation of tb_counter is

  component counter is
    generic(CLK_DIV_SCALE : integer := 10_000);
    port(clk     : in  std_logic;
         reset_n : in  std_logic;
         en      : in  std_logic;
         max_cnt :     natural range 0 to CLK_DIV_SCALE;
         Y       : out std_logic);
  end component;

  signal clk     : std_logic := '0';
  signal reset_n : std_logic := '0';
  signal max_cnt : natural range 0 to 8181;
  signal Y       : std_logic;

  signal TbPeriod   : time      := 20 ns;
  signal TbSimEnded : std_logic := '0';


begin

  dut : counter
    generic map(CLK_DIV_SCALE => 8191)
    port map(clk     => clk,
             reset_n => reset_n,
             max_cnt => max_cnt,
             en => '1',
             Y       => Y);

  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

  process
  begin
    max_cnt <= 0;
    reset_n <= '1';
    wait for TbPeriod;
    
    for itr in 0 to 20 loop
      max_cnt <= itr;
      wait for 200*TbPeriod;
    end loop;

    TbSimEnded <= '1';
    wait;
  end process;


end;
