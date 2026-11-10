-- Registrador de 8 bits feito de FF D com enable de escrita e clear assíncrono.
library ieee;
use ieee.std_logic_1164.all;

entity ff_d is
    port (
        clk    : in  std_logic;
        clear  : in  std_logic;
        enable : in  std_logic;
        d      : in  std_logic_vector(7 downto 0);
        q      : out std_logic_vector(7 downto 0)
    );
end ff_d;

architecture comportamento of ff_d is
    signal q_int : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(clk, clear)
    begin
        if clear = '1' then
            q_int <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                q_int <= d;
            end if;
        end if;
    end process;

    q <= q_int;
end comportamento;
