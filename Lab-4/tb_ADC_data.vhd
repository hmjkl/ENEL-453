library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ADC_Data is
end tb_ADC_Data;

architecture tb of tb_ADC_Data is

    component ADC_Data
        port (clk              : in std_logic;
              reset_n          : in std_logic;
              voltage          : out std_logic_vector (12 downto 0);
              distance         : out std_logic_vector (12 downto 0);
              ADC_raw          : out std_logic_vector (11 downto 0);
              ADC_out          : out std_logic_vector (11 downto 0)
				  );
    end component;

    signal clk              : std_logic;
    signal reset_n          : std_logic;
    signal voltage          : std_logic_vector (12 downto 0);
    signal distance         : std_logic_vector (12 downto 0);
    signal ADC_raw          : std_logic_vector (11 downto 0);
    signal ADC_out          : std_logic_vector (11 downto 0);

    constant TbPeriod : time := 20 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : ADC_Data
    port map (clk              => clk,
              reset_n          => reset_n,
              voltage          => voltage,
              distance         => distance,
              ADC_raw          => ADC_raw,
              ADC_out          => ADC_out
              -- ADC_out_high_res => ADC_out_high_res
				  );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed

        -- Reset generation
        -- EDIT: Check that reset_n is really your reset signal
        reset_n <= '0';
        wait for 100 ns;
        reset_n <= '1';
        wait for 100 ns;

        -- EDIT Add stimuli here
        wait for 15000 * TbPeriod;

        -- to figure out the expected stable output, we need to find
        -- the sum of each state. If we say that Y=sum of all state
        -- values = 2240+2244+2242+2240+2247+2245+2243+2246+2246+2245+2247
        -- Next, if we have 11 states and a 256 long shift_reg, then our
        -- states divide into 256 23 times with a remainder of 3. So our
        -- average will be given by (23*Y + 3 adjacent states)/256. However the
        -- math works out that any 3 adjacent state add to 6735, so avg shold
        -- be (23*24685+6735)/256 = 2244.
        assert ADC_out = std_logic_vector(to_unsigned(2244,ADC_out'length)) report "Incorrect average result";

        -- Just to show the output is stable, lets wait some more time.
        wait for 10 ms;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_ADC_Data of tb_ADC_Data is
    for tb
    end for;
end cfg_tb_ADC_Data;
