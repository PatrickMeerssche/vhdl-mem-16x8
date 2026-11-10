-- Testbench: cobre os 6 comportamentos pedidos na validação.
library ieee;
use ieee.std_logic_1164.all;

entity tb_memoria is
end tb_memoria;

architecture teste of tb_memoria is
    signal clk, clear, enable : std_logic := '0';
    signal addr  : std_logic_vector(3 downto 0) := "0000";
    signal D_in, D_out : std_logic_vector(7 downto 0) := (others => '0');

    procedure pulso(signal c : out std_logic) is
    begin
        -- espera as entradas (addr, D_in, enable) assentarem antes da borda; senão o FF amostra o valor antigo
        wait for 5 ns; c <= '1'; wait for 10 ns; c <= '0'; wait for 10 ns;
    end procedure;
begin
    dut : entity work.memoria port map (clk, clear, enable, addr, D_in, D_out);

    process
    begin
        -- 1) escrita em endereços diferentes
        enable <= '1';
        addr <= "0000"; D_in <= x"A5"; pulso(clk);
        addr <= "0011"; D_in <= x"3C"; pulso(clk);
        addr <= "1111"; D_in <= x"FF"; pulso(clk);
        enable <= '0';

        -- 2) e 3) leitura assíncrona: troca addr sem borda de clock
        addr <= "0000"; wait for 5 ns; assert D_out = x"A5" report "falha leitura 0" severity error;
        addr <= "0011"; wait for 5 ns; assert D_out = x"3C" report "falha leitura 3" severity error;
        addr <= "1111"; wait for 5 ns; assert D_out = x"FF" report "falha leitura 15" severity error;
        addr <= "0101"; wait for 5 ns; assert D_out = x"00" report "posição não escrita deveria ser 0" severity error;

        -- 4) enable='0' não altera a memória
        addr <= "0011"; D_in <= x"77"; pulso(clk);
        assert D_out = x"3C" report "escrita ocorreu com enable=0" severity error;

        -- 6) retenção: várias bordas sem escrita
        pulso(clk); pulso(clk);
        assert D_out = x"3C" report "dado não foi retido" severity error;

        -- 5) clear zera todas as posições
        clear <= '1'; wait for 5 ns; clear <= '0';
        addr <= "0000"; wait for 5 ns; assert D_out = x"00" report "clear falhou (0)" severity error;
        addr <= "1111"; wait for 5 ns; assert D_out = x"00" report "clear falhou (15)" severity error;

        report "Fim da simulação" severity note;
        wait;
    end process;
end teste;
