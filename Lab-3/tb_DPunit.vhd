library ieee;
use ieee.std_logic_1164.all;

entity tb_DPunit is
begin
end;

architecture Behavioral of tb_DPunit is

  component DPunit is
    port(s : in  std_logic_vector(1 downto 0);
         y : out std_logic_vector(6 downto 0));
  end component;

  signal s    : std_logic_vector(1 downto 0);
  signal y    : std_logic_vector(6 downto 0);
  constant dt : time := 20 ns;
begin

  dut : DPunit
    port map(s => s,
             y => y);

  process
  begin
    s <= "00";
    wait for dt;
    assert y = "0000000" report "Failed mode 0";

    s <= "01";
    wait for dt;
    assert y = "0001001" report "Failed mode 0";

    s <= "10";
    wait for dt;
    assert y = "0010000" report "Failed mode 0";

    s <= "11";
    wait for dt;
    assert y = "0000001" report "Failed mode 0";
    wait;
  end process;

end;
