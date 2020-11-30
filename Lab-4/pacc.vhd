library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pacc is
  generic(max_cnt : integer := 2**32 - 1);
  port(clk     : in  std_logic;
       en       : in std_logic;
       reset_n : in  std_logic;
       T       : in  natural range 0 to max_cnt;
       y       : out std_logic);
end;

architecture Behavioral of pacc is

  signal cnt : natural range 0 to max_cnt;
  type states is (HI, LO);
  signal cs  : states := HI;

  -- We found that adding this prevents the jitter on the distance from making
  -- the output freq fluctuate. All this serves to do is to prevent any
  -- 'clicking' on the audio output.
  signal T_tmp : natural range 0 to max_cnt;

begin

  seq : process(clk, reset_n)
  begin
    if reset_n = '0' then
      cnt <= 0;
      cs  <= HI;
    elsif rising_edge(clk) then
      if cnt = T_tmp then
        cnt   <= 0;
        T_tmp <= T;
        case cs is
          when HI =>
            cs <= LO;
          when LO =>
            cs <= HI;
        end case;
      else
        cnt <= cnt + 1;
      end if;
    end if;
  end process;

  comb : process(cs)
  begin
    if cs = HI or en = '0' then
      y <= '0';
    else
      y <= '1';
    end if;
  end process;


end;


--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--
--entity pacc is
--  generic(sz : integer := 32);
--  port(clk     : in  std_logic;
--       reset_n : in  std_logic;
--       T       : in  unsigned(sz - 1 downto 0);
--       y       : out std_logic);
--end;
--
--architecture Behavioral of pacc is
--
--  signal cnt   : unsigned(sz - 1 downto 0);
--  signal y_tmp : std_logic := '0';
--
--begin
--
--  seq : process(clk, reset_n)
--  begin
--    if reset_n = '0' then
--      cnt   <= (others => '0');
--    elsif rising_edge(clk) then
--      if cnt > T then
--        cnt <= (others => '0');
--      else
--        cnt <= cnt + 1;
--      end if;
--    end if;
--  end process;
--
--  comb : process(y_tmp, cnt, T)
--  begin
--    
--    if 2*cnt > T then
--      y_tmp <= '1';
--    else
--      y_tmp <= '0';
--    end if;
--
--    y <= y_tmp;
--  end process;
--
--end;

-- Need to map 0-> 0x28b0a, max_distance to 0x00000
