library ieee;
use ieee.std_logic_1164.all;
-- NOTE: this unit controls the decimal point location, and the leading zero
-- blanking (auto blanking).
entity DPunit is
  port(s : in  std_logic_vector(1 downto 0);
       y : out std_logic_vector(6 downto 0));
end;

architecture Behavioral of DPunit is

  component mux4 is
    generic(sz : integer := 1);
    port(d0 : in  std_logic_vector(sz - 1 downto 0);
         d1 : in  std_logic_vector(sz - 1 downto 0);
         d2 : in  std_logic_vector(sz - 1 downto 0);
         d3 : in  std_logic_vector(sz - 1 downto 0);
         s  : in  std_logic_vector(1 downto 0);
         y  : out std_logic_vector(sz - 1 downto 0));
  end component;

-- constants take the form of {DP_in[5], DP_in[4], ... , AutoBlank}.
  constant d0 : std_logic_vector(6 downto 0) := "0000000"; -- HEX
  constant d1 : std_logic_vector(6 downto 0) := "0001001"; -- DISTANCE
  constant d2 : std_logic_vector(6 downto 0) := "0010000"; -- VOLTAGE
  constant d3 : std_logic_vector(6 downto 0) := "0000001"; -- ADC

begin

  i_mux4_1 : mux4
    generic map(sz => 7)
    port map(d0 => d0,
             d1 => d1,
             d2 => d2,
             d3 => d3,
             s  => s,
             y  => y);
end;

