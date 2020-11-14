library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DFlip is
  generic(sz : integer := 1);
  port(clk     : in  std_logic;
       en      : in  std_logic;
       reset_n : in  std_logic;
       D       : in  std_logic_vector(sz - 1 downto 0);
       Q       : out std_logic_vector(sz -1 downto 0)
       );
end;

architecture Behavioral of DFlip is

begin

  process(clk, reset_n)
  begin
    if reset_n = '0' then
      Q <= (others => '0');
    elsif rising_edge(clk) then
      if en = '1' then
        Q <= D;
      end if;
    end if;
  end process;

end;
