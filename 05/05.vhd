library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.sine_package.all;

entity linearCombination_mixed is
    generic (
        inital : real := 1.0;
        coeffA : real := 1.0;
        coeddB : real := 1.0
    );
    port (
        inputA : in sine_vector_type;
        inputB : in real;
        outputt : out real := inital
    );
end entity linearCombination_mixed;

architecture behav of linearCombination_mixed is
signal out_signal : real := inital;
begin
    aync : process( inputA, inputB )
    begin
        out_signal <= ((Real(to_integer(signed(inputA)))*coeffA) + (inputB*coeddB));
    end process ; -- aync
    
    outputt <= out_signal; 
end behav ; -- behav