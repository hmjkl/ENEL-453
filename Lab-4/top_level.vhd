library ieee;
use ieee.std_logic_1164.all;


entity top_level is
  port(clk         : in  std_logic;
       SW          : in  std_logic_vector(9 downto 0);
       reset_n     : in  std_logic;
       freeze_n    : in  std_logic;
       LEDR        : out std_logic_vector(9 downto 0);
       ARDUNINO_IO : out std_logic_vector(15 downto 0);
       buzzer : out std_logic;
       HEX0        : out std_logic_vector(7 downto 0);
       HEX1        : out std_logic_vector(7 downto 0);
       HEX2        : out std_logic_vector(7 downto 0);
       HEX3        : out std_logic_vector(7 downto 0);
       HEX4        : out std_logic_vector(7 downto 0);
       HEX5        : out std_logic_vector(7 downto 0)
       );
end;



architecture Behavioral of top_level is

  component synchronizer is
    generic(sz : integer := 1);
    port(D   : in  std_logic_vector(sz - 1 downto 0);
         clk : in  std_logic;
         Q   : out std_logic_vector(sz -1 downto 0));
  end component;

  component debounce is
    generic(clk_freq    : integer := 50_000_000;  --system clock frequency in Hz
            stable_time : integer := 10);  --time button must remain stable in ms
    port(clk     : in  std_logic;       --input clock
         reset_n : in  std_logic;       --asynchronous active low reset
         button  : in  std_logic;       --input signal to be debounced
         result  : out std_logic);      --debounced signal
  end component;


  signal synced_SW          : std_logic_vector(9 downto 0);
  signal debounced_freeze_n : std_logic;

  component datapath is
    port(clk      : in  std_logic;
         SW       : in  std_logic_vector(9 downto 0);
         reset_n  : in  std_logic;
         freeze_n : in  std_logic;
         buzzer : out std_logic;
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

  i_debounce_1 : debounce
    generic map(clk_freq    => 50_000_000,
                stable_time => 30)
    port map(clk     => clk,
             reset_n => reset_n,
             button  => freeze_n,
             result  => debounced_freeze_n);

  i_syncronizer_1 : synchronizer
    generic map(sz => 10)
    port map(D   => SW,
             clk => clk,
             Q   => synced_SW);

  i_datapath_1 : datapath
    port map(clk      => clk,
             SW       => synced_SW,
             LEDR     => LEDR,
             buzzer => buzzer,
             reset_n  => reset_n,
             freeze_n => debounced_freeze_n,
             HEX0     => HEX0,
             HEX1     => HEX1,
             HEX2     => HEX2,
             HEX3     => HEX3,
             HEX4     => HEX4,
             HEX5     => HEX5);

end;
