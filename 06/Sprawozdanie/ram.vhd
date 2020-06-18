library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    generic (
        addres_line : integer := 7;
        data_size : integer := 7
    ); port (
        CSn : in std_logic;
        WEn : in std_logic;
        OEn : in std_logic;
        Address : in std_logic_vector(addres_line downto 0);
        Data : inout std_logic_vector(data_size - 1 downto 0)
    );
end memory;

architecture behav of memory IS
        signal data_line : std_logic_vector(data_size - 1 downto 0) := (others => 'Z');

        type ram_type is array (0 to 2**addres_line - 1) of std_logic_vector(data_size - 1 downto 0);
        signal ram_memory : ram_type := (others => (others => '0'));
    begin

        Data <= data_line when CSn = '0' and WEn = '1' and OEn = '0' else (others => 'Z');

        process( CSn, WEn, OEn )
            begin
                if CSn = '0' then -- Chip select
                    if falling_edge(WEn) then -- Write 
                        ram_memory(to_integer(unsigned(Address))) <= Data;
                    end if;

                    if OEn = '0' and WEn = '1' then -- Read
                        data_line <= ram_memory(to_integer(unsigned(Address)));
                    end if;
                end if;
        end process ; 

end architecture behav;