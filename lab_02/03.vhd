library ieee;
use ieee.std_logic_1164.all;

entity comparator is
  port(
    A : in std_logic_vector(1 downto 0);
    B : in std_logic_vector(1 downto 0);
    EQ : inout std_logic;
    GE : inout std_logic
);
end entity;

--architecture behavioral of comparator is
--	begin
--
--	EQ <= '1' when(A=B) else '0';
--	GE <= '1' when(A>=B) else '0';
--end behavioral;



architecture structural  of comparator is
	--A : in std_logic_vector(1 downto 0);
	--B : in std_logic_vector(1 downto 0);
	--EQ : inout std_logic;
	signal As : std_logic_vector(1 downto 0) := A;
	signal Bs : std_logic_vector(1 downto 0) := B;
begin
	As <= A;
	Bs <= B;
	EQ <= (not As(0) and not As(1) and not Bs(0) and not Bs(1)) or (not As(0) and As(1) and not Bs(0) and Bs(1)) or (As(0) and not As(1) and Bs(0) and not Bs(1)) or (As(0) and As(1) and Bs(0) and Bs(1));
	GE <= (not Bs(0) and not Bs(1)) or (As(1) and not Bs(0)) or (As(0) and not Bs(0)) or (As(0) and not Bs(1)) or (As(0) and As(1));
end structural;