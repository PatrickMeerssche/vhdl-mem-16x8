-- Memória RAM 16 x 8 (estrutural): decodificador 1:16 + 16 registradores FF D + mux 16:1.
-- Escrita síncrona (borda de subida, só com enable='1' na posição selecionada);
-- leitura assíncrona; clear assíncrono zera todas as posições.
library ieee;
use ieee.std_logic_1164.all;
use work.mem_pkg.all;

entity memoria is
    port (
        clk    : in  std_logic;
        clear  : in  std_logic;
        enable : in  std_logic;
        addr   : in  std_logic_vector(3 downto 0);
        D_in   : in  std_logic_vector(7 downto 0);
        D_out  : out std_logic_vector(7 downto 0)
    );
end memoria;

architecture comportamento of memoria is
    component ff_d is
        port (clk, clear, enable : in std_logic;
              d : in std_logic_vector(7 downto 0);
              q : out std_logic_vector(7 downto 0));
    end component;

    component decodificador is
        port (addr : in std_logic_vector(3 downto 0);
              sel  : out std_logic_vector(15 downto 0));
    end component;

    component mux16 is
        port (entradas : in banco_t;
              addr     : in std_logic_vector(3 downto 0);
              saida    : out std_logic_vector(7 downto 0));
    end component;

    signal sel   : std_logic_vector(15 downto 0);
    signal we    : std_logic_vector(15 downto 0);  -- enable de escrita de cada posição
    signal banco : banco_t;
begin
    u_dec : decodificador port map (addr => addr, sel => sel);

    gen_pos : for i in 0 to 15 generate
        we(i) <= sel(i) and enable;
        u_ff : ff_d port map (clk => clk, clear => clear, enable => we(i),
                              d => D_in, q => banco(i));
    end generate;

    u_mux : mux16 port map (entradas => banco, addr => addr, saida => D_out);
end comportamento;
