library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4 is
  generic(sz : integer := 1);
  port(d0 : in std_logic_vector(sz - 1 downto 0);
       d1 : in std_logic_vector(sz - 1 downto 0);
       d2 : in std_logic_vector(sz - 1 downto 0);
       d3 : in std_logic_vector(sz - 1 downto 0);
       s  : in std_logic_vector(1 downto 0);
       y  : out std_logic_vector(sz - 1 downto 0));
end;


architecture Behavioral of mux4 is

begin
  -- should be process(all), but quartus
  -- doesn't support VHDL 2008
  process(d0, d1, d2, d3, s) begin
     case s is
       when "00" => y <= d0;
       when "01" => y <= d1;
       when "10" => y <= d2;
       when "11" => y <= d3;
       -- handle undefined inputs
       when others => y <= (others => '0');
     end case;
  end process;
end;
