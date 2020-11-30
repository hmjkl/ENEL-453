library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This maps the range 0->4096 onto the range of 0->128. Arguably a
-- non-linear transformation is better because at a duty_cycle of greater
-- than 75% the perceived brightness change is very small. But that would
-- need another LUT. Mapping downto 128 gives us a precision 0.07% brightness
-- steps, an brightness steps at every 0.32cm (which is plenty to make the
-- brightness transistions smooth).

entity distance_mapper is
  port(distance       : in  std_logic_vector(12 downto 0);
       distance_trunc : out std_logic_vector(6 downto 0));
end;


architecture Behavioral of distance_mapper is
begin

  process(distance)
  begin
    if unsigned(distance) < to_unsigned(4000, distance'length) then
      distance_trunc <= distance(11 downto 5);
    else
      distance_trunc <= (others => '1');
    end if;
  end process;


end;
