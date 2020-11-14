library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity averager is
  generic(word_len : integer := 32;
          log2len  : integer := 8);
  port(clk     : in  std_logic;
       en      : in  std_logic;
       reset_n : in  std_logic;
       D       : in  std_logic_vector(word_len - 1 downto 0);
       Q       : out std_logic_vector(word_len - 1 downto 0);
       avg     : out std_logic_vector(word_len - 1 downto 0));
end;

architecture Behavioral of averager is

  constant p : integer := 2**log2len;
  subtype words is std_logic_vector(word_len - 1 downto 0);

  type shift_reg_mem is array (p - 1 downto 0) of words;
  signal smem : shift_reg_mem;

  -- This creates and oversize array, but the syth. tool is smart
  -- enouph to remove unused elements. Its also a good idea to put
  -- a range on (it gives about +4MHz to fmax).
  type adder_tree is array (0 to log2len - 1, 0 to p) of natural range 0 to (2**word_len - 1)*(2**log2len);
  signal amem : adder_tree;

begin

  shift_reg : process(clk, reset_n)
  begin
    if reset_n = '0' then
      smem <= (others => (others => '0'));
    elsif rising_edge(clk) then
      if en = '1' then
        smem(smem'high downto 1) <= smem(smem'high - 1 downto 0);
        smem(0)                  <= D;
      end if;
    end if;
  end process;

  --Q <= smem(smem'high);
  Q <= (others => '0');

  gen_layer_1 : for adder in 0 to p / 2 - 1 generate
    process(clk)
    begin
      if rising_edge(clk) then
        amem(0, adder) <= to_integer(unsigned(smem(2*adder))) + to_integer(unsigned(smem(2*adder + 1)));
      end if;
    end process;
  end generate gen_layer_1;

  gen_layer : for layer in 1 to log2len - 1 generate
    gen_adder : for adder in 0 to (2**log2len) / (2**(layer+1)) - 1 generate
      process(clk)
      begin
        if rising_edge(clk) then
          amem(layer, adder) <= amem(layer - 1, 2*adder) + amem(layer - 1, 2*adder + 1);
        end if;
      end process;
    end generate;
  end generate;

  process(clk, reset_n)
  begin
    if reset_n = '0' then
      avg <= (others => '0');
    elsif rising_edge(clk) and en = '1' then
      avg <= std_logic_vector(
        to_unsigned(amem(log2len - 1, 0), word_len + log2len)(word_len + log2len - 1 downto log2len));
    end if;
  end process;
end;
