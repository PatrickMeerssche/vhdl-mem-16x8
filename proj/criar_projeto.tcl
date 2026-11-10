# Cria o projeto Vivado da memória RAM 16x8 para a Boolean Board, sintetiza e gera o bitstream.
#
# Uso (a partir da pasta Trabalho-3bi, ou de qualquer lugar):
#   vivado -mode batch -source vivado/criar_projeto.tcl                   # cria + sintetiza + bitstream
#   vivado -mode batch -source vivado/criar_projeto.tcl -tclargs prog     # idem + grava na placa (USB ligado)
#   vivado -mode batch -source vivado/criar_projeto.tcl -tclargs sim      # só cria o projeto e roda o testbench
#   vivado -source vivado/criar_projeto.tcl -tclargs so_projeto           # só cria o projeto (abra no GUI depois)
#
# Boolean Board (Real Digital): Spartan-7 XC7S50-1CSGA324C. Confira o chip na placa se der erro de part.

set modo [expr {[llength $argv] > 0 ? [lindex $argv 0] : "bitstream"}]
set raiz [file normalize [file join [file dirname [info script]] ..]]
set proj_dir [file join $raiz vivado projeto]
set parte xc7s50csga324-1

create_project memoria_ram $proj_dir -part $parte -force

# Fontes: a ordem não importa, o Vivado resolve; o pacote mem_pkg está dentro de mux16.vhd.
# Fontes: a ordem não importa, o Vivado resolve; o pacote mem_pkg está dentro de mux16.vhd.
add_files [list \
    [file join $raiz proj ff_d.vhd] \
    [file join $raiz proj decodificador.vhd] \
    [file join $raiz proj mux16.vhd] \
    [file join $raiz proj Memoria.vhd] \
    [file join $raiz proj debounce_btn.vhd] \
    [file join $raiz proj toplevel.vhd]]
add_files -fileset constrs_1 [file join $raiz proj toplevel.xdc]
add_files -fileset sim_1 [file join $raiz sim tb_memoria.vhd]

set_property top toplevel [get_filesets sources_1]
set_property top tb_memoria [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

if {$modo eq "so_projeto"} { return }

if {$modo eq "sim"} {
    # Os asserts do testbench aparecem no log; "Fim da simulação" sem erro = passou.
    launch_simulation
    run all
    close_sim
    return
}

# Síntese + implementação + bitstream
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} { error "Síntese falhou (veja $proj_dir/memoria_ram.runs/synth_1/runme.log)" }

launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} { error "Implementação falhou (veja $proj_dir/memoria_ram.runs/impl_1/runme.log)" }

set bit [file join $proj_dir memoria_ram.runs impl_1 toplevel.bit]
puts "Bitstream gerado: $bit"

if {$modo eq "prog"} {
    open_hw_manager
    connect_hw_server
    open_hw_target
    set dev [lindex [get_hw_devices] 0]
    current_hw_device $dev
    set_property PROGRAM.FILE $bit $dev
    program_hw_devices $dev
    puts "Placa programada."
    close_hw_manager
}
