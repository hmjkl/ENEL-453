library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity reg is
  generic(sz : integer := 1);
  port(D : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       We : in STD_LOGIC;
       clk : in STD_LOGIC;
       reset_n : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(sz - 1 downto 0));
end;

architecture Behavioral of reg is
begin

  process(clk, reset_n, We) begin
    if (reset_n = '0') then
      Q <= (others => '0');
    elsif (rising_edge(clk)) then
      if (We = '0') then
        Q <= D;
      end if;
    end if;
  end process;

end;
