library IEEE; use IEEE.STD_LOGIC_1164.all;

entity mux2_tb is
end;


architecture sim of mux2_tb is

  component mux2 is
    port(d0, d1: in STD_LOGIC_VECTOR(15 downto 0);
         s: in STD_LOGIC;
         y: out STD_LOGIC_VECTOR(15 downto 0));
  end component;

  signal in0, in1, mout : STD_LOGIC_VECTOR(15 downto 0);
  signal msel           : STD_LOGIC;

  constant tdelay : time := 15 ns;

begin

  dut : mux2 port map (in0, in1, msel, mout);

    process begin
              assert false report "Starting testbench";
              in0 <= 16X"0"; in1 <= 16X"F"; msel <= '0'; wait for tdelay;
              assert mout = in0 report "Passed test 1";
              in0 <= 16X"A"; in1 <= 16X"F0F1"; msel <= '0'; wait for tdelay;
              assert mout = in0 report "Passed test 2";
              in0 <= 16X"0"; in1 <= 16X"F"; msel <= '1'; wait for tdelay;
              assert mout = in1 report "Passed test 3";
              in0 <= 16X"A"; in1 <= 16X"F0F1"; msel <= '1'; wait for tdelay;
              assert mout = in1 report "Passed test 4";

              assert false report "Testbench finished";
              wait;
    end process;

end;
