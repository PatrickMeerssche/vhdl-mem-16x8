-- Multiplexador 16:1 de 8 bits (leitura assíncrona: depende só de addr).
library ieee;
use ieee.std_logic_1164.all;

package mem_pkg is
    type banco_t is array (0 to 15) of std_logic_vector(7 downto 0);
end package;

library ieee;
use ieee.std_logic_1164.all;
use work.mem_pkg.all;

entity mux16 is
    port (
        entradas : in  banco_t;
        addr     : in  std_logic_vector(3 downto 0);
        saida    : out std_logic_vector(7 downto 0)
    );
end mux16;

architecture comportamento of mux16 is
begin
    with addr select
        saida <= entradas(0)  when "0000",
                 entradas(1)  when "0001",
                 entradas(2)  when "0010",
                 entradas(3)  when "0011",
                 entradas(4)  when "0100",
                 entradas(5)  when "0101",
                 entradas(6)  when "0110",
                 entradas(7)  when "0111",
                 entradas(8)  when "1000",
                 entradas(9)  when "1001",
                 entradas(10) when "1010",
                 entradas(11) when "1011",
                 entradas(12) when "1100",
                 entradas(13) when "1101",
                 entradas(14) when "1110",
                 entradas(15) when "1111",
                 (others => '0') when others;
end comportamento;
