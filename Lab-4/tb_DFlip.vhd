library ieee;
use ieee.std_logic_1164.all;

entity tb_DFlip is
end;

architecture tb of tb_DFlip is

  component DFlip is
    generic(sz : integer := 1);
    port(D       : in  std_logic_vector(sz - 1 downto 0);
         en      : in  std_logic;
         clk     : in  std_logic;
         reset_n : in  std_logic;
         Q       : out std_logic_vector(sz - 1 downto 0));
  end component;

  signal D, Q       : std_logic_vector(15 downto 0);
  signal clk        : std_logic := '0';
  signal en         : std_logic;
  signal reset_n    : std_logic;
  signal TbSimEnded : std_logic := '0';
  constant TbPeriod : time      := 20 ns;


begin

  dut : DFlip
    generic map(sz => 16)
    port map(D       => D,
             en      => en,
             clk     => clk,
             reset_n => reset_n,
             Q       => Q);

  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

  process
  begin
    -- Reset the DFF
    reset_n <= '0'; en <= '0'; wait for TbPeriod;
    reset_n <= '1'; wait for TbPeriod;

    -- Test that we must be active to write
    D <= X"FFFF";
    wait for TbPeriod;
    assert (Q = X"0000") report "Write enable check failed.";

    D <= X"CCCC";
    en <= '1';
    wait for TbPeriod/2;
    D <= X"A0A0";
    wait for TbPeriod/2;
    assert (Q = X"CCCC") report "Non blocking assignment check failed";

    en <= '0';
    wait for TbPeriod;
    reset_n <= '0'; wait for TbPeriod;
    assert (Q = X"0000") report "Reset check failed.";

    reset_n <= '1'; en <= '1'; wait for TbPeriod;
    assert (Q = X"A0A0") report "Reset latching check failed.";

    TbSimEnded <= '1';
    wait;
  end process;
end;
