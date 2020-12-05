library ieee;
use ieee.std_logic_1164.all;

entity tb_datapath is
begin
end;

architecture tb of tb_datapath is

  component datapath is
    port(clk      : in  std_logic;
         SW       : in  std_logic_vector(9 downto 0);
         reset_n  : in  std_logic;
         freeze_n : in  std_logic;
         buzzer   : out std_logic;
         LEDR     : out std_logic_vector(9 downto 0);
         HEX0     : out std_logic_vector(7 downto 0);
         HEX1     : out std_logic_vector(7 downto 0);
         HEX2     : out std_logic_vector(7 downto 0);
         HEX3     : out std_logic_vector(7 downto 0);
         HEX4     : out std_logic_vector(7 downto 0);
         HEX5     : out std_logic_vector(7 downto 0));
  end component;


  signal clk      : std_logic := '0';
  signal SW       : std_logic_vector(9 downto 0);
  signal reset_n  : std_logic := '0';
  signal freeze_n : std_logic;
  signal LEDR     : std_logic_vector(9 downto 0);
  signal HEX0     : std_logic_vector(7 downto 0);
  signal HEX1     : std_logic_vector(7 downto 0);
  signal HEX2     : std_logic_vector(7 downto 0);
  signal HEX3     : std_logic_vector(7 downto 0);
  signal HEX4     : std_logic_vector(7 downto 0);
  signal HEX5     : std_logic_vector(7 downto 0);

  signal buzzer : std_logic;

  constant tbperiod  : time      := 20 ns;
  signal TbSimEnded  : std_logic := '0';

  -- constants that will help find the expected HEX output
  constant H0    : std_logic_vector(7 downto 0) := "00111111";
  constant H1    : std_logic_vector(7 downto 0) := "00000110";
  constant H2    : std_logic_vector(7 downto 0) := "01011011";
  constant H3    : std_logic_vector(7 downto 0) := "01001111";
  constant H4    : std_logic_vector(7 downto 0) := "01100110";
  constant H5    : std_logic_vector(7 downto 0) := "01101101";
  constant H6    : std_logic_vector(7 downto 0) := "01111101";
  constant H7    : std_logic_vector(7 downto 0) := "00000111";
  constant H8    : std_logic_vector(7 downto 0) := "01111111";
  constant H9    : std_logic_vector(7 downto 0) := "01100111";
  constant Ha    : std_logic_vector(7 downto 0) := "01110111";
  constant Hb    : std_logic_vector(7 downto 0) := "01111100";
  constant Hc    : std_logic_vector(7 downto 0) := "00111001";
  constant Hd    : std_logic_vector(7 downto 0) := "01011110";
  constant He    : std_logic_vector(7 downto 0) := "01111001";
  constant Hf    : std_logic_vector(7 downto 0) := "01110001";
  constant DP    : std_logic_vector(7 downto 0) := "10000000";
  constant BLANK : std_logic_vector(7 downto 0) := "00000000";

  begin


  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';
  
  dut : datapath
    port map(clk      => clk,
             SW       => SW,
             reset_n  => reset_n,
             freeze_n => freeze_n,
             buzzer   => buzzer,
             LEDR     => LEDR,
             HEX0     => HEX0,
             HEX1     => HEX1,
             HEX2     => HEX2,
             HEX3     => HEX3,
             HEX4     => HEX4,
             HEX5     => HEX5);

  process
  begin
    freeze_n <= '1';
    wait for TbPeriod;
    reset_n <= '1';
    SW <= (1 => '1', others => '0');
    wait for TbPeriod;

    wait for 10 ms;
    

    assert false report "Simulation ended" severity failure;  -- need this line to halt the testbench  
    wait;
  end process;

end;

