library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- simple blanker circuit. For this circuit, we use a rule that to blank a hex
-- digit 3 things must be true (1) blanking is enabled (2) the hex digit to the
-- left must have gotten blanked (3) there must not be a DP on the hex digit.
-- From there this is a simple cascading logic circuit.

entity blanker is
  port(en        : in  std_logic;
       blank_in  : in  std_logic_vector(5 downto 0);
       DP_in     : in  std_logic_vector(5 downto 0);
       D         : in  std_logic_vector(23 downto 0);
       blank_out : out std_logic_vector(5 downto 0));
end;

architecture Behavioral of blanker is


  signal enlist    : std_logic_vector(5 downto 0);
  signal flaglist  : std_logic_vector(5 downto 0);
  signal DP_in_inv : std_logic_vector(5 downto 0);

begin

  enlist(5)          <= DP_in_inv(5);
  enlist(4 downto 0) <= flaglist(5 downto 1) and DP_in_inv(4 downto 0);

  DP_in_inv <= (not DP_in);

  gen_blanks : for itr in 5 downto 0 generate
    process (enlist, D, blank_in)
    begin
      if (enlist(itr)='1' and "0000" = D(itr*4 + 3 downto itr * 4)) or blank_in(itr) = '1' then
        flaglist(itr) <= '1';
      else
        flaglist(itr) <= '0';
      end if;
    end process;
  end generate gen_blanks;

  process(en, blank_in, flaglist)
  begin
    if en = '1' then
      blank_out <= flaglist;
    else
      blank_out <= blank_in;
    end if;
  end process;
  
end;
