library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is a simple counter. Unlike downcounter.vhd, this counter has a
-- variable reset/set number.

entity counter is
  generic(CLK_DIV_SCALE : natural := 10_000);
  port(clk     : in  std_logic;
       reset_n : in  std_logic;
       en      : in  std_logic;
       max_cnt : in natural range 0 to CLK_DIV_SCALE;
       Y       : out std_logic);
end;

architecture Behavioral of counter is

  signal cnt : natural range 0 to CLK_DIV_SCALE - 1 := max_cnt; -- This
                                                                -- assignment
                                                                -- helps to
                                                                -- supress a
                                                                -- "critical
                                                                -- warning"
                                                                -- that warns
                                                                -- of of
                                                                -- behavior we
                                                                -- want/expect.

begin

  process(clk, reset_n, max_cnt)
  begin

    if reset_n = '0' then
      cnt <= 0;
      Y <= '0';
    elsif rising_edge(clk) and en = '1' then
      if cnt = 0 or cnt = 1 then -- cnt = 0 check is to ensure that setting
                                 -- max_cnt to 0 will not break operation.
                                 -- Usually we would perfer the cnt = 1 check
                                 -- as it results in more accurate counting
        Y <= '1';
        cnt <= max_cnt;
      else
        cnt <= cnt - 1;
        Y   <= '0';
      end if;
    end if;

  end process;

end;
