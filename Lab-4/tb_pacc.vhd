library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_pacc is
begin
end;

architecture Behavioral of tb_pacc is

  component pacc is
    generic(sz : integer := 32);
    port(clk     : in  std_logic;
         reset_n : in  std_logic;
         T       : in  unsigned(sz - 1 downto 0);
         y       : out std_logic);
  end component;


  signal clk     : std_logic := '0';
  signal reset_n : std_logic := '0';
  signal T       : unsigned(11 downto 0);
  signal y       : std_logic;

  signal TbPeriod : time := 20 ns;
  signal TbSimEnded  : std_logic := '0';

begin

  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';
   
  dut : pacc
    generic map(sz => 12)
    port map(clk     => clk,
             reset_n => reset_n,
             T       => T,
             y       => y);

  process
  begin
    T <= X"0F0";
    wait for TbPeriod;
    reset_n <= '1';
    wait for 500*TbPeriod; 
    TbSimEnded <= '1';
    wait for TbPeriod;
    wait;
  end process;
  
end;
