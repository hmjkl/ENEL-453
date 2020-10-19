library ieee;
use ieee.std_logic_1164.all;

entity tb_mux4 is
end tb_mux4;

architecture tb of tb_mux4 is
  
  component mux4
    generic (sz : integer := 1);
    port (d0 : in std_logic_vector (sz - 1 downto 0);
          d1 : in std_logic_vector (sz - 1 downto 0);
          d2 : in std_logic_vector (sz - 1 downto 0);
          d3 : in std_logic_vector (sz - 1 downto 0);
          s  : in std_logic_vector (1 downto 0);
          y  : out std_logic_vector (sz - 1 downto 0));
  end component;
  
  signal d0 : std_logic_vector (15 downto 0);
  signal d1 : std_logic_vector (15 downto 0);
  signal d2 : std_logic_vector (15 downto 0);
  signal d3 : std_logic_vector (15 downto 0);
  signal s  : std_logic_vector (1 downto 0);
  signal y  : std_logic_vector (15 downto 0);

  constant tdelay : time := 20 ns;
  
begin
  
  dut : mux4
    generic map (sz => 16)
    port map (d0 => d0,
              d1 => d1,
              d2 => d2,
              d3 => d3,
              s  => s,
              y  => y);
  
  stimuli : process
  begin
    d0 <= (others => '0');
    d1 <= (others => '0');
    d2 <= (others => '0');
    d3 <= (others => '0');
    s <= (others => '0');
    
    d0 <= X"AAAA";
    d1 <= X"BBBB";
    d2 <= X"CCCC";
    d3 <= X"DDDD";

    wait for tdelay;

    s <="01"; wait for tdelay;
    s <="10"; wait for tdelay;
    s <="11"; wait for tdelay;
    
    
    wait;
  end process;
  
end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_mux4 of tb_mux4 is
  for tb
  end for;
end cfg_tb_mux4;
