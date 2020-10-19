library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity tb_reg is
end;

architecture tb of tb_reg is

component reg is
  generic(sz : integer := 1);
  port(D : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       We : in STD_LOGIC;
       clk : in STD_LOGIC;
       reset_n : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(sz - 1 downto 0));
end component;

signal D, Q : STD_LOGIC_VECTOR(15 downto 0);
signal clk : STD_LOGIC := '0';
signal We : STD_LOGIC;
signal reset_n : STD_LOGIC;
signal TbSimEnded : STD_LOGIC := '0';
constant TbPeriod : time := 20 ns;


begin

  dut : reg
    generic map(sz => 16)
    port map(D => D,
             We => We,
             clk => clk,
             reset_n => reset_n,
             Q => Q);
  
  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

  process begin
    reset_n <= '0'; We <= '0'; wait for TbPeriod;
    reset_n <= '1'; wait for TbPeriod;

    D <= X"FFFF"; wait for TbPeriod;

    assert (Q = X"0000") report "Write enable check failed.";

    D <= X"CCCC"; We <= '1'; wait for TbPeriod/2;
    D <= X"A0A0"; wait for TbPeriod/2;
    assert (Q = X"CCCC") report "Non blocking assignment check failed";

    We <= '0'; wait for TbPeriod;

    reset_n <= '0'; wait for TbPeriod;
    assert (Q = X"0000") report "Reset check failed.";

    reset_n <= '1'; We <= '1'; wait for TbPeriod;
    assert (Q = X"A0A0") report "Reset latching check failed.";

    TbSimEnded <= '1';
    wait;
  end process;
end;
