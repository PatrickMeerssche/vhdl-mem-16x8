#!/usr/bin/env bash
# Compila na ordem certa, roda o testbench no GHDL e gera a forma de onda (sim/tb.ghw).
# Uso: ./sim/rodar.sh          (só roda os asserts)
#      ./sim/rodar.sh --ver    (abre o GTKWave depois)
set -e
cd "$(dirname "$0")/.."
W=$(mktemp -d)
ghdl -a --std=08 --workdir=$W vhdl/ff_d.vhd vhdl/decodificador.vhd vhdl/mux16.vhd vhdl/Memoria.vhd \
     vhdl/debounce_btn.vhd vhdl/toplevel.vhd sim/tb_memoria.vhd
ghdl -e --std=08 --workdir=$W tb_memoria
ghdl -r --std=08 --workdir=$W tb_memoria --wave=sim/tb.ghw   # "assertion error" na saída = teste falhou
[ "$1" = "--ver" ] && gtkwave sim/tb.ghw
rm -rf "$W"
