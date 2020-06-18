library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;

entity decimator is
  generic(
    delay : time := 4 ns;
	  FS : integer := 0; -- NOT USED IN PROJECT
	  OSR : integer := 4
          );
  port(
      clk : in std_logic;
      data_in : in std_logic;
      data_out : out integer := 0
    );
end entity decimator;

architecture behav of decimator is
  signal state : integer := OSR;
  signal current_value : integer := OSR;
  signal data_out_value : integer  := OSR;

begin

  clk_process: process (clk) begin
    state <= state - 1 after delay;

    if data_in = '1' then
      current_value <= current_value + 1 after delay;
    else 
      current_value <= current_value - 1 after delay;
    end if;
    
    if state = 0 then
      state <= OSR;
      data_out_value <= current_value;
      current_value <= OSR;
    end if;

  end process clk_process;

  data_out <= data_out_value after delay;
     
end architecture behav;    