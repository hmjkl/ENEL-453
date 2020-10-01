library IEEE; use IEEE.STD_LOGIC_1164.all;

entity mux16 is
	port(d0, d1: in STD_LOGIC_VECTOR(15 downto 0);
			s: in STD_LOGIC;
			y: out STD_LOGIC_VECTOR(15 downto 0));
end;

architecture synth of mux16 is
begin
	y <= d1 when s='1' else d0;
end;