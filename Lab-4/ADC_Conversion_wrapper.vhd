library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity ADC_Conversion_wrapper is
  port(MAX10_CLK1_50      : in  std_logic;
       response_valid_out : out std_logic;
       ADC_out            : out std_logic_vector (11 downto 0)
       );
end ADC_Conversion_wrapper;

architecture RTL of ADC_Conversion_wrapper is

  component ADC_Conversion is           -- test_ADC is  
    port(MAX10_CLK1_50      : in  std_logic;
         response_valid_out : out std_logic;
         ADC_out            : out std_logic_vector (11 downto 0)
         );
  end component;

begin
  ADC_Conversion_ins : ADC_Conversion port map(  -- test_ADC  PORT MAP(      
    MAX10_CLK1_50      => MAX10_CLK1_50,
    response_valid_out => response_valid_out,
    ADC_out            => ADC_out
    );

end RTL;

architecture simulation of ADC_Conversion_wrapper is
  signal counter              : std_logic_vector(3 downto 0) := (others => '0');
  signal response_valid_out_i : std_logic;

  -- This is the number of cycles to wait between changing the upper bits of ADC_out
  constant cnt_delta : natural := 5000;

begin

  response_valid_out   <= response_valid_out_i;

  response_valid_out_process : process
    variable cnt : natural := 0;
    variable timeElapsed : time := 0 ps;
  begin
    cnt := cnt + 1;
    if cnt < cnt_delta then
      ADC_out(11 downto 3) <= "100011000";
    elsif cnt < 2*cnt_delta then
      ADC_out(11 downto 3) <= "001101101";
    else
      wait;
    end if;


    response_valid_out_i <= '0'; wait for 980 ns;
    response_valid_out_i <= '1'; wait for 20 ns;
  end process;

  ADC_out_process : process (response_valid_out_i)  -- modify the lower 3 ADC bits
  begin
    if rising_edge(response_valid_out_i) then
      case counter is
        when "0000" =>
          ADC_out(2 downto 0) <= "000";
          counter             <= "0001";

        when "0001" =>
          ADC_out(2 downto 0) <= "100";
          counter             <= "0010";

        when "0010" =>
          ADC_out(2 downto 0) <= "010";
          counter             <= "0011";

        when "0011" =>
          ADC_out(2 downto 0) <= "000";
          counter             <= "0100";

        when "0100" =>
          ADC_out(2 downto 0) <= "111";
          counter             <= "0101";

        when "0101" =>
          ADC_out(2 downto 0) <= "101";
          counter             <= "0110";

        when "0110" =>
          ADC_out(2 downto 0) <= "011";
          counter             <= "0111";

        when "0111" =>
          ADC_out(2 downto 0) <= "110";
          counter             <= "1000";

        when "1000" =>
          ADC_out(2 downto 0) <= "110";
          counter             <= "1001";

        when "1001" =>
          ADC_out(2 downto 0) <= "101";
          counter             <= "1011";

        when others =>
          ADC_out(2 downto 0) <= "111";
          counter             <= "0000";

      end case;
    end if;
  end process;


end simulation;
