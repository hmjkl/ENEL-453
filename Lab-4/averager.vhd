library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- note: this averager always has high res bits enabled, but they can be set
-- to 0 to exclude them (as we have done in ADC_data). It should be noted that
-- non-zero high-res bits will shift the output magnitude, so if used the DP on
-- the display would need to shift. This also has an "en" signal added to each
-- of the adder DFFs, which comes with a small cost of about 0.5 MHz, but makes
-- writing the testbenches a breeze and seems to reduce jitter on the display.

entity averager is
  generic(word_len : integer := 32;
          log2len  : integer := 8;
          hi_res_bits : integer := 4);
  port(clk     : in  std_logic;
       en      : in  std_logic;
       reset_n : in  std_logic;
       D       : in  std_logic_vector(word_len - 1 downto 0);
       avg     : out std_logic_vector(word_len + hi_res_bits - 1 downto 0));
end;

architecture Behavioral of averager is

  constant p : integer := 2**log2len;
  subtype words is std_logic_vector(word_len - 1 downto 0);

  type shift_reg_mem is array (p - 1 downto 0) of words;
  signal smem : shift_reg_mem;

  -- This creates and oversize array, but the syth tool is smart
  -- enouph to remove unused elements. Its also a good idea to put a
  -- range on to prevent the default 32-bit numbers (it gives about
  -- +2MHz to fmax for free).
  subtype tree_nautral is natural range 0 to (2**word_len - 1)*(2**log2len);
  type adder_tree_mem is array (0 to log2len - 1, 0 to p) of tree_nautral;
  signal amem : adder_tree_mem;

begin

  shift_reg : process(clk, reset_n)
  begin
    if reset_n = '0' then
      smem <= (others => (others => '0'));
    elsif rising_edge(clk) and en='1' then
      if en = '1' then
        smem(smem'high downto 1) <= smem(smem'high - 1 downto 0);
        smem(0)                  <= D;
      end if;
    end if;
  end process;

  -- We need to manually generate the fist layer because of type conversion.
  gen_layer_1 : for adder in 0 to p / 2 - 1 generate
    process(clk, reset_n)
    begin
      if reset_n = '0' then
        amem(0,adder) <= 0;
      elsif rising_edge(clk) and en = '1' then
        amem(0, adder) <= to_integer(unsigned(smem(2*adder))) + to_integer(unsigned(smem(2*adder + 1)));
      end if;
    end process;
  end generate gen_layer_1;

  -- We need log2len total layers
  gen_layer : for layer in 1 to log2len - 1 generate
    -- our layer size should halve every layer
    gen_adder : for adder in 0 to (2**log2len) / (2**(layer+1)) - 1 generate
      process(clk, reset_n)
      begin
        if reset_n = '0' then
          amem(layer, adder) <= 0;
        elsif rising_edge(clk) and en='1' then
          -- add two adjacent nodes from the previous layer
          amem(layer, adder) <= amem(layer - 1, 2*adder) + amem(layer - 1, 2*adder + 1);
        end if;
      end process;
    end generate;
  end generate;

      avg <= std_logic_vector(
        to_unsigned(amem(log2len - 1, 0), word_len + log2len)(word_len + log2len - 1 downto log2len - hi_res_bits));

end;
