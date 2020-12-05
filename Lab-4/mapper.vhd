library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- A simple entity to make the RTL easier to see. All it does is check if
-- distance < cond. If it is, d1 is selected, and if not d0 is selected.

entity mapper is
  generic(cond : integer := 777);
  port(distance : in  unsigned(12 downto 0);
       d0       : in  std_logic;
       d1       : in  std_logic;
       Y        : out std_logic);
end;

architecture Behavioral of mapper is
begin

  process(distance, d0, d1)
  begin
    if distance < to_unsigned(cond, distance'length) then
      Y <= d1;
    else
      Y <= d0;
    end if;
  end process;

end;
