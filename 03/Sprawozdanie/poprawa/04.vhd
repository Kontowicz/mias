library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity linearCombination is
    generic (
        inital : real := 1.0;
        coeffA : real := 1.0;
        coeddB : real := 1.0
    );
    port (
        inputA : in real;
        inputB : in real;
        outputt : out real := inital
    );
end entity linearCombination;

architecture behav of linearCombination is
signal out_signal : real := inital;
begin
    aync : process( inputA, inputB )
    begin
        out_signal <= ((inputA*coeffA) + (inputB*coeddB));
    end process ; -- aync
    
    outputt <= out_signal; 
end behav ; -- behav