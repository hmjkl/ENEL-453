library IEEE; use IEEE.STD_LOGIC_1164.all;

entity tb_mux2 is
end;


architecture sim of tb_mux2 is

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
              assert mout = in0 report "Failed test 1";
              in0 <= 16X"A"; in1 <= 16X"F0F1"; msel <= '0'; wait for tdelay;
              assert mout = in0 report "Failed test 2";
              in0 <= 16X"0"; in1 <= 16X"F"; msel <= '1'; wait for tdelay;
              assert mout = in1 report "Failed test 3";
              in0 <= 16X"A"; in1 <= 16X"F0F1"; msel <= '1'; wait for tdelay;
              assert mout = in1 report "Failed test 4";
              in0 <= 16X"FFFF"; in1 <= 16X"0000"; msel <= '1'; wait for tdelay;
              assert mout = in1 report "Failed test 5";
              in0 <= 16X"FFFF"; in1 <= 16X"0000"; msel <= '0'; wait for tdelay;
              assert mout = in0 report "Failed test 5";

              assert false report "Testbench finished";
              wait;
    end process;

end;
