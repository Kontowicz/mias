library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity clock is
  generic(start : std_logic := '0';
	  period : time := 10ns
          );
  port(
          clk : inout std_logic := start
    );
end entity;

architecture behav of clock is

begin
clk <= not clk after period/2;
end architecture behav;    