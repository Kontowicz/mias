library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mar is
    generic(
        addres_line : integer := 7
    );
    port (
        inc_adr : in std_logic;
        address : out std_logic_vector(addres_line downto 0)
    );
end mar;

architecture behav of mar is
        signal addr : std_logic_vector(addres_line downto 0) := (others => '0');
    begin
        proc : process( inc_adr )
            begin
                if rising_edge(inc_adr) then
                    addr <= std_logic_vector(unsigned(addr) + 1);

                    if unsigned(addr) = (2**addres_line - 1) then
                         addr <= (others => '0');
                    end if;
                end if;
        end process ; -- proc
        
        address <= addr;
end behav ; -- behav