# Memória RAM 16x8 em VHDL (Spartan-7 / Boolean Board)

Projeto de memória RAM estrutural de 16 palavras de 8 bits (128 bits no total) desenvolvido para a disciplina de Sistemas Digitais (3º bimestre) na Universidade Federal do Rio Grande (FURG).

**Autores:** Rômulo Maciel & Patrick Guasti Vande Meerssche  
**Professor:** Rafael Schivittz  
**Placa Alvo:** Real Digital Boolean Board (AMD / Xilinx Spartan-7 `xc7s50csga324-1`)

---

## 🏗️ Arquitetura do Circuito

O projeto foi implementado de forma **estritamente estrutural**:
- **16 Registradores de 8 bits (`ff_d.vhd`)**: Células de armazenamento com Flip-Flops tipo D, enable de escrita e clear assíncrono.
- **Decodificador 1:16 (`decodificador.vhd`)**: Decodifica o endereço de 4 bits (`addr[3:0]`) para habilitar exclusivamente a posição selecionada (`sel[15:0]`).
- **Multiplexador 16:1 de 8 bits (`mux16.vhd`)**: Roteia o conteúdo lido assincronamente da palavra selecionada para a saída `D_out[7:0]`.
- **Top-Level da Memória (`Memoria.vhd`)**: Integração estrutural com escrita síncrona com `we(i) = sel(i) and enable`.
- **Filtro Anti-Bounce (`debounce_btn.vhd`)**: Debounce digital no botão de clock manual com histerese temporal de 10 ms baseada no clock de 100 MHz.
- **Top-Level da Placa (`toplevel.vhd`) & Restrições (`toplevel.xdc`)**: Mapeamento dos pinos físicos para a Boolean Board.

---

## 🎮 Mapeamento de Hardware (Boolean Board)

| Sinal | Componente na Placa | Função |
| :--- | :--- | :--- |
| `addr[3:0]` | `SW0` a `SW3` | Barramento de endereço (0 a 15) |
| `D_in[7:0]` | `SW4` a `SW11` | Barramento de dados de entrada |
| `enable` | `SW12` | Habilita a escrita no registrador selecionado |
| `clear` | `SW13` | Reset assíncrono global de todos os 16 registradores |
| `clock` | `BTN0` | Pulso manual de clock (filtrado com debounce) |
| `D_out[7:0]` | `LD0` a `LD7` | Barramento de dados de saída (leitura contínua/assíncrona) |
| `addr[3:0]` | `LD8` a `LD11` | Espelhamento visual do endereço selecionado |

---

## 📂 Estrutura de Diretórios

```
├── proj/               # Fontes VHDL (.vhd), restrições (.xdc) e script TCL do Vivado
├── sim/                # Testbench VHDL (tb_memoria.vhd)
├── SLIDES/             # Apresentação do projeto e fotos da placa
├── Entrega/            # Arquivos empacotados para submissão acadêmica
└── vivado/             # Projeto Vivado (.xpr)
```

---

## 🚀 Como Executar

### Simulação ou Recriação do Projeto Vivado
Execute o script TCL via Vivado batch:
```bash
vivado -mode batch -source proj/criar_projeto.tcl
```
Ou com parâmetros:
- `vivado -mode batch -source proj/criar_projeto.tcl -tclargs prog` (gera bitstream e programa a placa)
- `vivado -mode batch -source proj/criar_projeto.tcl -tclargs sim` (cria projeto e executa a simulação)
