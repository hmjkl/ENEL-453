library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- This is a recursive averager. It breaks an averager into two equal peices,
-- inserts a register between them and computes their sum on every clock edge.
-- We only consider the base case of len = 2, so if len is not a power of two
-- the averager will not work.

entity rec_averager is
  generic(word_len : integer := 32;
          len      : integer := 8);
  port(clk : in     std_logic;
       D   : in     std_logic_vector(word_len - 1 downto 0);
       en  : in     std_logic;
       Q   : buffer std_logic_vector(word_len - 1 downto 0);
       sum : out    integer);
end;

architecture Behavioral of rec_averager is

  signal left_Q  : std_logic_vector(word_len - 1 downto 0);
  signal right_Q : std_logic_vector(word_len - 1 downto 0);
  signal right_D : std_logic_vector(word_len - 1 downto 0);

  signal left_sum  : integer;
  signal right_sum : integer;

begin

  basis : if len = 2 generate
    process(clk, D, Q)
    begin
      if rising_edge(clk) then
        if en = '1' then
          Q <= D;
        end if;
        sum <= to_integer(unsigned(D)) + to_integer(unsigned(Q));
      end if;
    end process;
  end generate basis;

  averager_tree : if len > 2 generate
    left_side : rec_averager
      generic map(word_len => word_len,
                  len      => len / 2)
      port map(clk => clk,
               D   => D,
               Q   => left_Q,
               en  => en,
               sum => left_sum);

    right_side : rec_averager
      generic map(word_len => word_len,
                  len      => len / 2)
      port map(clk => clk,
               D   => right_D,
               Q   => Q,
               en  => en,
               sum => right_sum);

    process(clk)
    begin
      if rising_edge(clk) then
        right_D <= left_Q;
        sum     <= right_sum + left_sum;
      end if;
    end process;
  end generate averager_tree;
end;
