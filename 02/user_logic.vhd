library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity user_logic is
    generic (
        N : integer := 7;
        period : time := 20 ns
    );
    port(
        clk : out std_logic := '0';
        reset_n : out std_logic;
        i2c_ack_err : in std_logic;                    
        temperature : in std_logic_vector(N downto 0) := "00000000"
    );                   
end user_logic;

architecture ul of user_logic IS
    signal clk_s : std_logic := '0';
    begin
        reset_n <= '0', '1' after 18 ns;
        
        process begin
            wait for period/2;
            clk_s <= not clk_s;
        end process;
        clk <= clk_s;

end architecture ul;