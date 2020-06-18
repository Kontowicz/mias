
library ieee;
use ieee.std_logic_1164.all;

entity gen is
  port(
  CLK : inout BIT;
  S1 : out std_logic;
  S2 : out std_logic;
  S3 : out std_logic_vector (1 downto 0);
  S4 : out INTEGER
);
end entity;

architecture behavioral of gen is
  signal sCLK : BIT := '0';
  signal sS1 : std_logic := '1';
  signal sS2 : std_logic := '1';
  signal sS3 : std_logic_vector (1 downto 0) := "01";
  signal sS4 : INTEGER := 2;
  
  begin
    sCLK <= not sCLK after 20ns;
    sS1 <= not sS1 after 10ns;
    sS2 <= '0' after 10ns, '1' after 30ns, '0' after 50ns;
    sS3 <= "00" after 10ns, "11" after 20ns;
    sS4 <= 5 after 10ns;
    
    CLK <= sCLK;
    S1 <= sS1;
    S2 <= sS2;
    S3 <= sS3;
    S4 <= sS4;
end behavioral;