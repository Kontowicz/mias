library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity tb is
end tb;

architecture behav of tb is
        constant addres_line : integer := 4;
        constant data_size : integer := 7;
        constant period : time := 20 ns;

        signal CSn_signal : std_logic;
        signal WEn_signal : std_logic;
        signal OEn_signal : std_logic;
        signal Address_signal : std_logic_vector(addres_line  downto 0);
        signal Data_signal : std_logic_vector(data_size - 1 downto 0);
        signal inc_addr_signal : std_logic;
        signal ld_data_signal : std_logic;
        signal en_data_signal : std_logic;
        signal inc_data_signal : std_logic;
    begin 

        ram_dev : entity work.memory generic map(
            addres_line => addres_line,
            data_size => data_size
        ) port map(
            CSn => CSn_signal,
            WEn => WEn_signal,
            OEn => OEn_signal,
            Address => Address_signal,
            Data => Data_signal
        );

        mar_dev : entity work.mar generic map(
            addres_line => addres_line
        ) port map(
            inc_adr => inc_addr_signal,
            address => Address_signal
        );

        data_register_dev : entity work.data_register generic map(
            data_size => data_size
        ) port map(
            ld_data => ld_data_signal,
            en_data => en_data_signal,
            inc_data => inc_data_signal,
            data => Data_signal
        );

        controler_dev : entity work.control generic map(
            addres_line => addres_line,
            data_size => data_size,
            period => period
        ) port map(
            CSn => CSn_signal,
            OEn => OEn_signal,
            WEn => WEn_signal,
            inc_addr => inc_addr_signal,
            ld_data => ld_data_signal,
            en_data => en_data_signal,
            inc_data => inc_data_signal
        );

        
end behav ; -- behav