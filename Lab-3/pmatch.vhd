library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pmatch is
  generic(sz : integer := 32);
  port(X        : in std_logic_vector(sz - 1 downto 0);
       en       : in std_logic;
       match    : in std_logic_vector(sz - 1 downto 0);
       flag     : out std_logic);
end;

architecture Behavioral of pmatch is

begin

  process(X, en, match) begin
    if en = '1' and X = match then
      flag <= '1';
    else
      flag <= '0';
    end if;
  end process;

end;
