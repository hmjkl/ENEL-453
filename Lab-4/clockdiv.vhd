library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--entity clkdiv is
--  generic(N : integer := 2); 
--  port (clk : in std_logic;
--        Q : out std_logic_vector(

entity clockdiv is
  generic(log2len : integer := 2);
  port(clk_div : out std_logic_vector(log2len - 1 downto 0));
end;

architecture Behavioral of clockdiv is

  signal T : std_logic_vector(log2len - 1 downto 0);

begin

  process(clk)
  begin
    if rising_edge(clk) then
      clk_div <= 
  end process;
  
end;

--entity clockdiv is
--  generic(log2len : integer := 2);
--  port(clk     : in  std_logic;
--       clk_div : out std_logic_vector(log2len - 1 downto 0));
--end;
--
--architecture Recursive of clockdiv is
--
--  constant N : integer := 2**log2len;
--  signal D : std_logic;
--  signal Q : std_logic;
--
--begin
--
--  basis : if N = 2 generate
--    D       <= not Q;
--    clk_div(0) <= Q;
--    process(clk)
--    begin
--      if rising_edge(clk) then
--        Q <= D;
--      end if;
--    end process;
--  end generate basis;
--
--  rec : if N > 2 generate
--
--    D <= not Q;
--
--    process(clk)
--    begin
--      if rising_edge(clk) then
--        Q <= D;
--      end if;
--    end process;
--
--    i_clockdiv : clockdiv
--      generic map(log2len => log2len - 1)
--      port map(clk => D,
--               clk_div => clk_div(clk_div'high downto 1));
--  end generate rec;
--
--  --basis : if d = 2 generate
--
--  --  T <= not clk_d;
--
--  --  process(clk)
--  --  begin
--  --    if rising_edge(clk) then
--  --      clk_d <= T;
--  --    end if;
--  --  end process;
--  --end generate basis;
--
--  --rec : if d > 2 generate
--
--  --  process(clk)
--  --  begin
--  --    i_clockdiv : clockdiv
--  --      generic map(d => d / 2)
--  --      port map(clk => T,
--  --               clk_d => clk_d);
--  --  end process;
--
--  --end generate rec;
--
--end;
