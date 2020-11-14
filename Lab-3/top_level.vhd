library IEEE;
use IEEE.STD_LOGIC_1164.all;


entity top_level is
  port(clk      : in  std_logic;
       SW       : in  std_logic_vector(9 downto 0);
       reset_n  : in  std_logic;
       freeze_n : in  std_logic;
       LEDR     : out std_logic_vector(9 downto 0);
       HEX0     : out std_logic_vector(7 downto 0);
       HEX1     : out std_logic_vector(7 downto 0);
       HEX2     : out std_logic_vector(7 downto 0);
       HEX3     : out std_logic_vector(7 downto 0);
       HEX4     : out std_logic_vector(7 downto 0);
       HEX5     : out std_logic_vector(7 downto 0)
       );
end;



architecture Behavioral of top_level is


  component datapath is
    port(clk      : in  std_logic;
         SW       : in  std_logic_vector(9 downto 0);
         reset_n  : in  std_logic;
         freeze_n : in  std_logic;
         LEDR     : out std_logic_vector(9 downto 0);
         HEX0     : out std_logic_vector(7 downto 0);
         HEX1     : out std_logic_vector(7 downto 0);
         HEX2     : out std_logic_vector(7 downto 0);
         HEX3     : out std_logic_vector(7 downto 0);
         HEX4     : out std_logic_vector(7 downto 0);
         HEX5     : out std_logic_vector (7 downto 0)
         );
  end component;

begin

  LEDR <= SW;

  i_datapath_1 : datapath
    port map(clk      => clk,
             SW       => SW,
             reset_n  => reset_n,
             freeze_n => freeze_n,
             HEX0     => HEX0,
             HEX1     => HEX1,
             HEX2     => HEX2,
             HEX3     => HEX3,
             HEX4     => HEX4,
             HEX5     => HEX5);

end;
