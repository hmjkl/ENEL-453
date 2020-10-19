library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity tb_datapath is
end;
                            
architecture tb of tb_datapath is

component datapath is
  port(clk                           : in STD_LOGIC;
       reset_n                       : in STD_LOGIC;
       store_val                     : in STD_LOGIC;
       SW                            : in STD_LOGIC_VECTOR(9 downto 0);
       LEDR                          : out STD_LOGIC_VECTOR(9 downto 0);
       HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : out STD_LOGIC_VECTOR(7 downto 0));
end component;

signal clk                           : STD_LOGIC := '0';
signal reset_n                       : STD_LOGIC;
signal store_val                     : STD_LOGIC;
signal SW                            : STD_LOGIC_VECTOR(9 downto 0);
signal LEDR                          : STD_LOGIC_VECTOR(9 downto 0);
signal HEX0,HEX1,HEX2,HEX3,HEX4,HEX5 : STD_LOGIC_VECTOR(7 downto 0);

type mode is (DEC, HEX, STORE, CONST);

signal state : mode;
signal TbSimEnded : STD_LOGIC := '0';
constant TbPeriod : time := 20 ns;

  -- modified seven segment values (include dp = 0)
  constant H0 : STD_LOGIC_VECTOR(7 downto 0) := (not "00111111");
  constant H1 : STD_LOGIC_VECTOR(7 downto 0) := (not "00000110");
  constant H2 : STD_LOGIC_VECTOR(7 downto 0) := (not "01011011");
  constant H3 : STD_LOGIC_VECTOR(7 downto 0) := (not "01001111");
  constant H4 : STD_LOGIC_VECTOR(7 downto 0) := (not "01100110");
  constant H5 : STD_LOGIC_VECTOR(7 downto 0) := (not "01101101");
  constant H6 : STD_LOGIC_VECTOR(7 downto 0) := (not "01111101");
  constant H7 : STD_LOGIC_VECTOR(7 downto 0) := (not "00000111");
  constant H8 : STD_LOGIC_VECTOR(7 downto 0) := (not "01111111");
  constant H9 : STD_LOGIC_VECTOR(7 downto 0) := (not "01100111");
  constant Ha : STD_LOGIC_VECTOR(7 downto 0) := (not "01110111");
  constant Hb : STD_LOGIC_VECTOR(7 downto 0) := (not "01111100");
  constant Hc : STD_LOGIC_VECTOR(7 downto 0) := (not "00111001");
  constant Hd : STD_LOGIC_VECTOR(7 downto 0) := (not "01011110");
  constant He : STD_LOGIC_VECTOR(7 downto 0) := (not "01111001");
  constant Hf : STD_LOGIC_VECTOR(7 downto 0) := (not "01110001");


begin

  dut : datapath
    port map(clk => clk,
             reset_n => reset_n,
             store_val => store_val,
             SW => SW,
             LEDR => LEDR,
             HEX0 => HEX0,
             HEX1 => HEX1,
             HEX2 => HEX2,
             HEX3 => HEX3,
             HEX4 => HEX4,
             HEX5 => HEX5);

  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

  process begin
            reset_n <= '0';
            store_val <= '0';
            SW <= (others => '0');

            wait for TbPeriod;

            assert (HEX0 = H0) report "Failed test 0 (0)";
            assert (HEX1 = H0) report "Failed test 0 (1)";
            assert (HEX2 = H0) report "Failed test 0 (2)";
            assert (HEX3 = H0) report "Failed test 0 (3)";

            reset_n <= '1';
            store_val <= '1';
            SW <= (3 downto 0 => '1', others => '0');
                       
            wait for 1000*TbPeriod;

            assert (HEX0 = H5) report "Failed test 1 (0)";
            assert (HEX1 = H1) report "Failed test 1 (1)";
            assert (HEX2 = H0) report "Failed test 1 (2)";
            assert (HEX3 = H0) report "Failed test 1 (3)";

            store_val <= '0';

            wait for 50*TbPeriod;

            store_val <= '1';

            wait for 50*TbPeriod;

            SW(8) <= '1';

            wait for 1000*TbPeriod;
            
            assert (HEX0 = Hf) report "Failed test 2 (0)";
            assert (HEX1 = H0) report "Failed test 2 (1)";
            assert (HEX2 = H0) report "Failed test 2 (2)";
            assert (HEX3 = H0) report "Failed test 2 (3)";

            sw(9) <= '1';

            wait for 1000*TbPeriod;

            assert (HEX0 = Ha) report "Failed test 3 (0)";
            assert (HEX1 = H5) report "Failed test 3 (1)";
            assert (HEX2 = Ha) report "Failed test 3 (2)";
            assert (HEX3 = H5) report "Failed test 3 (3)";

            sw(8) <= '0';

            wait for 1000*TbPeriod;
            assert (HEX0 = H5) report "Failed test 4 (0)";
            assert (HEX1 = H1) report "Failed test 4 (1)";
            assert (HEX2 = H0) report "Failed test 4 (2)";
            assert (HEX3 = H0) report "Failed test 4 (3)";

            wait for 1000*TbPeriod;


            TbSimEnded <= '1';
            wait;
  end process;
            
  
end;
