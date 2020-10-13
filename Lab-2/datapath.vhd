library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
  port(clk                           : in STD_LOGIC;
       reset_n                       : in STD_LOGIC;
       store_val                     : in STD_LOGIC;
       SW                            : in STD_LOGIC_VECTOR(9 downto 0);
       LEDR                          : out STD_LOGIC_VECTOR (9 downto 0);
       HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR (7 downto 0));
end;

architecture Behavioral of datapath is

component mux4 is
  generic(sz : integer := 1);
  port(d0 : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       d1 : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       d2 : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       d3 : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       s  : in STD_LOGIC_VECTOR(1 downto 0);
       y  : out STD_LOGIC_VECTOR(sz - 1 downto 0));
end component;

component DFF_C is
  generic(sz : integer := 1);
  port(D : in STD_LOGIC_VECTOR(sz - 1 downto 0);
       we : in STD_LOGIC;
       clk : in STD_LOGIC;
       Q : out STD_LOGIC_VECTOR(sz - 1 downto 0));
end component;

component binary_bcd is
  port(clk      :  IN    STD_LOGIC;                                
       reset_n  :  IN    STD_LOGIC;                                
       binary   :  IN    STD_LOGIC_VECTOR(12 DOWNTO 0);         
       bcd      :  OUT   STD_LOGIC_VECTOR(15 DOWNTO 0));  
end component;

component SevenSegment is
  port(DP_in,Blank                                           : in  STD_LOGIC_VECTOR (5 downto 0);
       Num_Hex0,Num_Hex1,Num_Hex2,Num_Hex3,Num_Hex4,Num_Hex5 : in  STD_LOGIC_VECTOR (3 downto 0);
       HEX0,HEX1,HEX2,HEX3,HEX4,HEX5                         : out STD_LOGIC_VECTOR (7 downto 0));
end component; 

signal Q : STD_LOGIC_VECTOR(15 downto 0);
signal bcd : STD_LOGIC_VECTOR(15 downto 0);
signal mux_switch_in : STD_LOGIC_VECTOR(15 downto 0);
signal bcd_switch_in : STD_LOGIC_VECTOR(12 downto 0);
signal hex_ins : STD_LOGIC_VECTOR(15 downto 0);


signal Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 : STD_LOGIC_VECTOR (3 downto 0):= (others=>'0');   
signal DP_in, Blank:  STD_LOGIC_VECTOR (5 downto 0);

begin

LEDR <= SW;

mux_switch_in <= "00000000" & SW(7 downto 0);
bcd_switch_in <= "00000" & SW(7 downto 0);

i_bcd_1 : binary_bcd
  port map(clk => clk,
           reset_n => reset_n,
           binary => bcd_switch_in,
           bcd => bcd);

i_DFF_1 : DFF_C
  generic map(sz => 16)
  port map(D => hex_ins,
			  We => (not store_val),
           clk => clk,
           Q => Q);

i_mux4_1 : mux4
  generic map(sz => 16)
  port map(d0 => bcd,
           d1 => mux_switch_in,
           d2 => Q,
           d3 => x"5A5A",
           s  => sw(9 downto 8),
           y  => hex_ins);

Num_Hex0 <= hex_ins(3  downto  0); 
Num_Hex1 <= hex_ins(7  downto  4);
Num_Hex2 <= hex_ins(11 downto  8);
Num_Hex3 <= hex_ins(15 downto 12);
Num_Hex4 <= "0000";
Num_Hex5 <= "0000";   
DP_in    <= "000000";
Blank    <= "110000";
  

i_SevenSegment_1 : SevenSegment
  port map(Num_Hex0 => Num_Hex0,
           Num_Hex1 => Num_Hex1,
           Num_Hex2 => Num_Hex2,
           Num_Hex3 => Num_Hex3,
           Num_Hex4 => Num_Hex4,
           Num_Hex5 => Num_Hex5,
           Hex0     => Hex0,
           Hex1     => Hex1,
           Hex2     => Hex2,
           Hex3     => Hex3,
           Hex4     => Hex4,
           Hex5     => Hex5,
           DP_in    => DP_in,
           Blank    => Blank);

end;
  
