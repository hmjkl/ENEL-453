library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity DFF_C is
  generic(sz : integer := 1);
  port(D : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       We : in STD_LOGIC;
       clk : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(sz - 1 downto 0));
end;

architecture Behavioral of DFF_C is
begin

  process(clk) begin
    if (rising_edge(clk)) then
	   if (We = '1') then
        Q <= D;
		end if;
    end if;
  end process;

end;
