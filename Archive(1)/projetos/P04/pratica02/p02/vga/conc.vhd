library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity concatenador is
    Port (
        a : in  STD_LOGIC_VECTOR(9 downto 0); -- linha
        b : in  STD_LOGIC_VECTOR(9 downto 0); -- coluna
        y : out STD_LOGIC_VECTOR(14 downto 0)
    );
end concatenador;

architecture Behavioral of concatenador is
begin
    -- 7 bits de 'a' + 8 bits de 'b' = 15 bits
    y <= a(6 downto 0) & b(7 downto 0);
end Behavioral;