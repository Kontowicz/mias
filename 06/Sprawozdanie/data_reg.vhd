library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_register is 
    generic(
        data_size : integer := 7
    ); port (
        ld_data : in std_logic;
        en_data : in std_logic;
        inc_data : in std_logic;
        data : inout std_logic_vector(data_size - 1 downto 0) := (others => 'Z')
    );
end data_register;

architecture behav of data_register is
        signal data_signal_hold : std_logic_vector(data_size - 1 downto 0);
        signal data_signal_out : std_logic_vector(data_size - 1 downto 0) := (others => 'Z');
    begin
        proc : process( ld_data, inc_data )
            begin
                if rising_edge(ld_data) then
                    data_signal_hold <= data;
                end if;

                if rising_edge(en_data) then
                    data_signal_out <= data_signal_hold;
                end if;

                if rising_edge(inc_data) then
                    data_signal_hold <= std_logic_vector(unsigned(data_signal_hold) + 1);
                end if;
        end process ; -- proc

        data <= (others => 'Z') when en_data = '0' else data_signal_out;
        
end behav ; -- behav