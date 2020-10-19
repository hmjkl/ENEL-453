library IEEE; use IEEE.STD_LOGIC_1164.ALL;

-- top level file only connects synchronous circuit
-- to input protections.

entity top_level is
  port(clk                           : in STD_LOGIC;
       reset_n                       : in STD_LOGIC;
       store_val                     : in STD_LOGIC;
       SW                            : in STD_LOGIC_VECTOR(9 downto 0);
       LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
       HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0));
end;

architecture Behavioral of top_level is

component datapath is
  port(clk                           : in STD_LOGIC;
       reset_n                       : in STD_LOGIC;
       store_val                     : in STD_LOGIC;
       SW                            : in STD_LOGIC_VECTOR(9 downto 0);
       LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
       HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component synchronizer is
  generic(sz : integer := 1);
  port(D : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       clk : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(sz -1 downto 0));
end component;

component debounce is
  generic(clk_freq    : INTEGER := 50_000_000;  --system clock frequency in Hz
          stable_time : INTEGER := 10);         --time button must remain stable in ms
  port(clk     : IN  STD_LOGIC;  --input clock
       reset_n : IN  STD_LOGIC;  --asynchronous active low reset
       button  : IN  STD_LOGIC;  --input signal to be debounced
       result  : OUT STD_LOGIC); --debounced signal
END component;


signal synced_switches : STD_LOGIC_VECTOR(9 downto 0);
signal debounced_store_val : STD_LOGIC;

begin

  i_debounce_1 : debounce
    generic map(clk_freq    => 50_000_000,
                stable_time => 30)
    port map(clk => clk,
             reset_n => reset_n,
             button  => store_val,
             result  => debounced_store_val);

switch_sync : synchronizer
  generic map(sz => 10)
  port map(D => SW,
           clk => clk,
           Q => synced_switches);
  
i_datapath_1 : datapath
  port map(clk => clk,
           reset_n => reset_n,
           store_val => debounced_store_val,
           SW => synced_switches,
           LEDR => LEDR,
           Hex0 => Hex0,
           Hex1 => Hex1,
           Hex2 => Hex2,
           Hex3 => Hex3,
           Hex4 => Hex4,
           Hex5 => Hex5);
           
  
end;
