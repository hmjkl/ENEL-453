library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity tb_blanker is
begin
end;


architecture Sim of tb_blanker is

component blanker is
  port(en        : in  std_logic;
       blank_in  : in  std_logic_vector(5 downto 0);
       DP_in     : in  std_logic_vector(5 downto 0);
       D         : in  std_logic_vector(23 downto 0);
       blank_out : out std_logic_vector(5 downto 0));
end component;


signal en        : std_logic;
signal blank_in  : std_logic_vector(5 downto 0);
signal DP_in     : std_logic_vector(5 downto 0);
signal D         : std_logic_vector(23 downto 0);
signal blank_out : std_logic_vector(5 downto 0);

constant dt : time := 20 ns;

begin

  dut : blanker
    port map(en => en,
             blank_in => blank_in,
             DP_in => DP_in,
             D => D,
             blank_out => blank_out);
      
    process
    begin

      en <= '0';
      blank_in <= (others => '0');
      DP_in <= (others => '0');
      D <= (others => '0');
      wait for dt;

      -- test blanking all digits
      en <= '1';
      D <= X"000000";
      wait for dt;
      assert blank_out = "111111" report "Failed test 1";

      --test blanking some digits
      D <= X"0AB0D0";
      wait for dt;
      assert blank_out = "100000" report "Failed test 2";

      --test decimal protection
      D <= X"000000";
      DP_in <= "100000";
      wait for dt;
      assert blank_out = "000000" report "Failed test 3";

      --test blank pass through (ie continue blanking manually blanked
      --numbers.
      D <= X"FF0DED";
      DP_in <= (others => '0');
      blank_in <= "110000";
      wait for dt;
      assert blank_out = "111000" report "Failed test 4";

      --test en
      en <= '0';
      wait for dt;
      assert blank_out = blank_in report "Failed test 5";
      
      wait;
    end process;
end;
