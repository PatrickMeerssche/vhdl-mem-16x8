-- Debounce do botão usado como clock manual (~10 ms com clock de placa de 50 MHz).
library ieee;
use ieee.std_logic_1164.all;

entity debounce_btn is
    generic (CICLOS : integer := 500_000);
    port (
        clk   : in  std_logic;
        botao : in  std_logic;
        saida : out std_logic
    );
end debounce_btn;

architecture comportamento of debounce_btn is
    signal estavel  : std_logic := '0';
    signal contador : integer range 0 to CICLOS := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if botao /= estavel then
                if contador < CICLOS - 1 then
                    contador <= contador + 1;
                else
                    contador <= 0;
                    estavel  <= botao;
                end if;
            else
                contador <= 0;
            end if;
        end if;
    end process;

    saida <= estavel;
end comportamento;
