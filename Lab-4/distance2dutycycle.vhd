library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.LED_LUT_pkg.all;

-- This maps the range 0->4096 onto the range of 0->128. Arguably a
-- non-linear transformation is better because at a duty_cycle of greater
-- than 75% the perceived brightness change is very small. But that would
-- need another LUT. Mapping downto 128 gives us a precision 0.07% brightness
-- steps, an brightness steps at every 0.32cm (which is plenty to make the
-- brightness transistions smooth).

entity distance2duty is
  port(distance       : in  unsigned(12 downto 0);
       duty_cycle : out unsigned(7 downto 0));
end;


architecture Behavioral of distance2duty is
begin

      duty_cycle <= to_unsigned((d2d_LUT(to_integer(distance(11 downto 4)))),duty_cycle'length);
      --distance_trunc <= to_unsigned((d2d_LUT(to_integer(unsigned(distance srl 4)))),distance_trunc'length);

end;
