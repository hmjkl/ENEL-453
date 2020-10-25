library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity tb_synchronizer is
end;

architecture tb of tb_synchronizer is

component synchronizer is
  generic(sz : integer := 1);
  port(D : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       clk : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(sz -1 downto 0));
end component;
  
signal D, Q : STD_LOGIC_VECTOR(15 downto 0);
signal clk : STD_LOGIC := '0';

signal TbSimEnded : STD_LOGIC := '0';
constant TbPeriod : time := 20 ns;


begin

  dut : synchronizer
    generic map(sz => 16)
    port map(D   => D,
             clk =>clk,
             Q   => Q);
  
  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

  process begin

    D <= (others => '0');
    wait for TbPeriod;
    assert (Q /= X"0000") report "Failed test 1";

    wait for TbPeriod/8;
    D <= X"A0A0";
    wait for TbPeriod/8;
    D <= X"FFFF";

    wait for TbPeriod/4;
    D <= X"0000";

    wait for TbPeriod/2;

    assert (Q = X"0000") report "Failed test 2";

    wait for TbPeriod;

    assert (Q = X"FFFF") report "Failed test 3";

    TbSimEnded <= '1';
    wait;
  end process;
end;
