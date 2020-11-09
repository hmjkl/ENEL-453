-- --- Seven segment component
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity SevenSegment is
  port (DP_in, Blank                                               : in  std_logic_vector (5 downto 0);
        Num_Hex0, Num_Hex1, Num_Hex2, Num_Hex3, Num_Hex4, Num_Hex5 : in  std_logic_vector (3 downto 0);
        AutoBlank                                                  : in  std_logic;
        HEX0, HEX1, HEX2, HEX3, HEX4, HEX5                         : out std_logic_vector (7 downto 0)
        );
end SevenSegment;
architecture Behavioral of SevenSegment is

--Note that component declaration comes after architecture and before begin (common source of error).
  component SevenSegment_decoder is
    port(H         : out std_logic_vector (7 downto 0);
         input     : in  std_logic_vector (3 downto 0);
         DP, Blank : in  std_logic
         );
  end component;

  component pmatch is
    generic(sz : integer := 32);
    port(X     : in  std_logic_vector(sz - 1 downto 0);
         en    : in  std_logic;
         match : in  std_logic_vector(sz - 1 downto 0);
         flag  : out std_logic);
  end component;

  signal AutoB : std_logic_vector(5 downto 0);
  signal Blank_sum : std_logic_vector(5 downto 0);
  signal DP_inv : std_logic_vector(5 downto 0);
begin

--Blanking portion: Will blank leading zeros, or any explcitly blanked
--numbers

  DP_inv <= not DP_in;
  
  i_pmatch_1 : pmatch
    generic map(sz => 4)
    port map(X     => Num_Hex0,
             en    => AutoB(1) and DP_inv(0),
             match => "0000",
             flag  => AutoB(0));

  i_pmatch_2 : pmatch
    generic map(sz => 4)
    port map(X     => Num_Hex1,
             en    => AutoB(2) and DP_inv(1),
             match => "0000",
             flag  => AutoB(1));

  i_pmatch_3 : pmatch
    generic map(sz => 4)
    port map(X     => Num_Hex2,
             en    => AutoB(3) and DP_inv(2),
             match => "0000",
             flag  => AutoB(2));

  i_pmatch_4 : pmatch
    generic map(sz => 4)
    port map(X     => Num_Hex3,
             en    => AutoB(4) and DP_inv(3),
             match => "0000",
             flag  => AutoB(3));

  i_pmatch_5 : pmatch
    generic map(sz => 4)
    port map(X     => Num_Hex4,
             en    => AutoB(5) and DP_inv(4),
             match => "0000",
             flag  => AutoB(4));

  i_pmatch_6 : pmatch
    generic map(sz => 4)
    port map(X     => Num_Hex5,
             en    => AutoBlank and DP_inv(5),
             match => "0000",
             flag  => AutoB(5));


  Blank_sum <= Blank or AutoB;

  decoder0 : SevenSegment_decoder port map
    (H     => Hex0,
     input => Num_Hex0,
     Blank => Blank_sum(0),
     DP    => DP_in(0)
     );
  decoder1 : SevenSegment_decoder port map
    (H     => Hex1,
     input => Num_Hex1,
     Blank => Blank_sum(1),
     DP    => DP_in(1)
     );
  decoder2 : SevenSegment_decoder port map
    (H     => Hex2,
     input => Num_Hex2,
     Blank => Blank_sum(2),
     DP    => DP_in(2)
     );
  decoder3 : SevenSegment_decoder port map
    (H     => Hex3,
     input => Num_Hex3,
     Blank => Blank_sum(3),
     DP    => DP_in(3)
     );
  decoder4 : SevenSegment_decoder port map
    (H     => Hex4,
     input => Num_Hex4,
     Blank => Blank_sum(4),
     DP    => DP_in(4)
     );
  decoder5 : SevenSegment_decoder port map
    (H     => Hex5,
     input => Num_Hex5,
     Blank => Blank_sum(5),
     DP    => DP_in(5)
     );
end Behavioral;
