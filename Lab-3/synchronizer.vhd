library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity synchronizer is
  generic(sz : integer := 1);
  port(D : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       clk : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(sz -1 downto 0));
end;

architecture Behavioral of synchronizer is

  signal n : STD_LOGIC_VECTOR(sz - 1 downto 0);

begin

  process(clk) begin
    if (rising_edge(clk)) then
      n <= D;
      Q <= n;
    end if;
  end process;
end;
