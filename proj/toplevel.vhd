-- Toplevel para a Boolean Board (16 switches, 4 botões, 16 LEDs, clock de 100 MHz).
--   sw(3..0)  = addr        sw(11..4) = D_in
--   sw(12)    = enable      sw(13)    = clear
--   btn(0)    = clock manual (com debounce)
--   led(7..0) = D_out       led(11..8) = addr (para conferir a posição na demonstração)
library ieee;
use ieee.std_logic_1164.all;

entity toplevel is
    port (
        clk : in  std_logic;
        sw  : in  std_logic_vector(13 downto 0);
        btn : in  std_logic_vector(0 downto 0);
        led : out std_logic_vector(11 downto 0)
    );
end toplevel;

architecture estrutura of toplevel is
    component debounce_btn is
        generic (CICLOS : integer := 500_000);
        port (clk, botao : in std_logic; saida : out std_logic);
    end component;

    component memoria is
        port (clk, clear, enable : in std_logic;
              addr  : in std_logic_vector(3 downto 0);
              D_in  : in std_logic_vector(7 downto 0);
              D_out : out std_logic_vector(7 downto 0));
    end component;

    signal clk_manual : std_logic;
begin
    u_deb : debounce_btn
        generic map (CICLOS => 1_000_000)  -- 10 ms a 100 MHz
        port map (clk => clk, botao => btn(0), saida => clk_manual);

    u_mem : memoria port map (
        clk    => clk_manual,
        clear  => sw(13),
        enable => sw(12),
        addr   => sw(3 downto 0),
        D_in   => sw(11 downto 4),
        D_out  => led(7 downto 0)
    );

    led(11 downto 8) <= sw(3 downto 0);
end estrutura;
