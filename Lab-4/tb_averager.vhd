library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity tb_averager is
end;

architecture tb of tb_averager is

  component averager is
    generic(word_len : integer := 32;
            hi_res_bits : integer := 4;
            log2len  : integer := 8);
    port(clk     : in  std_logic;
         en      : in  std_logic;
         reset_n : in  std_logic;
         D       : in  std_logic_vector(word_len - 1 downto 0);
         avg     : out std_logic_vector(hi_res_bits + word_len - 1 downto 0));
  end component;

  signal clk     : std_logic := '0';
  signal en      : std_logic := '1';
  signal reset_n : std_logic := '0';
  signal D       : std_logic_vector(11 downto 0);
  signal avg     : std_logic_vector(11 downto 0); -- the averager result before the
                                                  -- decimal point
  signal avg_DP : std_logic_vector(3 downto 0); -- the averager result after
                                                -- the DP
  signal avg_precise : std_logic_vector(11 + 4 downto 0); -- the whole averager
                                                          -- result

  constant tbperiod : time      := 20 ns;
  signal TbSimEnded : std_logic := '0';


begin

  clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

  dut : averager
    generic map(word_len => 12,
                hi_res_bits => 4,
                log2len  => 8)
    port map(clk     => clk,
             en      => en,
             reset_n => reset_n,
             D       => D,
             avg     => avg_precise);

  avg <= avg_precise(avg_precise'high downto 4);
  avg_DP <=avg_precise(3 downto 0);

  process
  begin

    wait for TbPeriod;
    reset_n <= '1';

    -- This loads 0 to 255 into the shift registers.
    for S in 0 to 255 loop
      D <= std_logic_vector(to_unsigned(S, D'length));
      wait for tbperiod;
    end loop;

    -- Our shift register and the avg output have 9 register layers between
    -- then (8 adder register layers and 1 layer used for en and reset_n), so
    -- we need to wait an additonal 9 periods for the average of 0->255 to appear.
    D <= (others => '0');
    wait for 9*TbPeriod;
    assert avg = std_logic_vector(to_unsigned(127,avg'length)) report "Failed average 0 to 255";
    -- next, we should test the decimal point. For the average of 0->255, the
    -- decimal average is 127.5, which using a hex calculator is 0x7f.8, so
    -- avg_DP is 0x8
    assert avg_DP = X"8" report "Failed to calculate DP for 0 to 255";

    -- Waiting 1 period gives the avg of 0,255,244,....,3,2,1 which is still 127
    wait for TbPeriod;
    assert avg = std_logic_vector(to_unsigned(127,avg'length)) report "Failed average 0 to 255 (Part 2)";

    -- If we wait one more period, the average is avg(2,3,....,244,255) which
    -- is 0x7f.7e, but we floor our DP, so avg_DP should be 0x7
    wait for TbPeriod;
    assert avg_DP = X"7" report "Failed to calculate DP for 2 to 255";
    
    wait for 16*TbPeriod;


    -- test asynchronous reset
    reset_n <= '0';
    wait for 0.5*TbPeriod;
    assert avg = X"000" report "Failed reset_n blanking";
    wait for 0.5*TbPeriod;

    -- this should load 0's into the shiftreg
    wait for 256*TbPeriod;
    -- this waits for the addders to sum the results
    wait for 9*TbPeriod;
    -- after reset_n is swithed, the output should be avg(0,0,0.....,0) = 0
    reset_n <= '1';
    wait for TbPeriod;
    assert avg = X"000" report "Failed averaging zeros";

    -- Testing rollover (the output should not roll over and should be all ones).
    D <= (others => '1');
    wait for 256*TbPeriod;
    wait for 9*TbPeriod;
    assert avg = X"FFF" report "Failed rollover test";
               
    TbSimEnded <= '1';
    wait;

  end process;

end;
