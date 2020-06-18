library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use STD.textio.all;
use ieee.std_logic_textio.all;

entity decimator_tb is 
generic (
	constant in_file : string := "input_file.txt";
	constant out_file : string := "output_file.txt";
	constant OSR : integer := 4
);
end entity;

architecture behav of decimator_tb is
signal clock_signal : std_logic;
signal data_in_signal : std_logic;
signal data_out_signal : integer;

file input_file : text;
file output_file : text;
constant period_tb : time := 10ns;
constant delay : time := 1ns;
begin
	d_clock : entity work.clock generic map(start=>'0', period=>period_tb)
			port map(clk=>clock_signal);
	d_decimator : entity work.decimator generic map(delay=>delay,FS=>0,OSR=>OSR)
			     port map(clk=>clock_signal, data_in=>data_in_signal,data_out=>data_out_signal);

	process 
		variable v_ILINE : line;
   		variable datastrem_bit : std_logic;
   	  
  	begin
    	file_open(input_file, in_file,  read_mode);
    	while not endfile(input_file) loop
  			readline(input_file, v_ILINE);
      		read(v_ILINE, datastrem_bit);
      		data_in_signal <= datastrem_bit after delay;
    		wait for period_tb/2;
    	end loop;
    	file_close(input_file);
		std.env.finish;
	end process;
	  
	process (data_out_signal)
		variable v_OLINE     : line;
	begin
		file_open(output_file, out_file, append_mode);
		write(v_OLINE, data_out_signal, right, 1);
		writeline(output_file, v_OLINE);
		file_close(output_file);

	end process;
	
end architecture behav;