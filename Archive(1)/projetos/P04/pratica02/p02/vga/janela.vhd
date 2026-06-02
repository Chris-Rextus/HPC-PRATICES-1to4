library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mascara_janela is
    Port (
        pixel_row    : in  STD_LOGIC_VECTOR(9 downto 0);
        pixel_column : in  STD_LOGIC_VECTOR(9 downto 0);
        video_out    : out STD_LOGIC
    );
end mascara_janela;

architecture Behavioral of mascara_janela is
begin

    process(pixel_row, pixel_column)
    begin
        if (unsigned(pixel_column) < 256 and 
            unsigned(pixel_row) < 128) then
            
            video_out <= '1';
        else
            video_out <= '0';
        end if;
    end process;

end Behavioral;