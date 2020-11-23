library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pacc is
  generic(sz : integer := 32);
  port(clk     : in  std_logic;
       reset_n : in  std_logic;
       T       : in  unsigned(sz - 1 downto 0);
       y       : out std_logic);
end;

architecture Behavioral of pacc is

  signal cnt   : unsigned(sz - 1 downto 0);
  signal y_tmp : std_logic := '0';

begin

  seq : process(clk, reset_n)
  begin
    if reset_n = '0' then
      cnt   <= (others => '0');
    elsif rising_edge(clk) then
      if cnt > T then
        cnt <= (others => '0');
      else
        cnt <= cnt + 1;
      end if;
    end if;
  end process;

  comb : process(y_tmp, cnt, T)
  begin
    
    if 2*cnt > T then
      y_tmp <= '1';
    else
      y_tmp <= '0';
    end if;

    y <= y_tmp;
  end process;

end;

-- Need to map 0-> 0x28b0a, max_distance to 0x00000
