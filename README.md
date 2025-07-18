Estudo de Arquitetura de Computadores: MIPS e VLIW
Este repositório documenta meu estudo prático e implementação de diferentes arquiteturas de processadores, começando com as variações do MIPS e evoluindo para um processador VLIW. O objetivo é aplicar os conceitos teóricos de arquitetura e organização de computadores em projetos funcionais.

🎯 Objetivos do Projeto
O roteiro deste projeto consiste na implementação das seguintes arquiteturas, com cada uma sendo desenvolvida em duas plataformas para fins de comparação e aprendizado:

1. MIPS Monociclo:

[ ] Implementação em Logisim Evolution

[ ] Implementação em Verilog HDL

2. MIPS Multiciclo:

[ ] Implementação em Logisim Evolution

[ ] Implementação em Verilog HDL

3. MIPS com Pipeline:

[ ] Implementação em Logisim Evolution

[ ] Implementação em Verilog HDL

4. Processador VLIW (Very Long Instruction Word):

[ ] Concepção e implementação da arquitetura final.

🛠️ Ferramentas e Tecnologias
Logisim Evolution: Utilizado para o design visual, simulação e depuração dos circuitos lógicos de forma gráfica.

Verilog HDL: Uma linguagem de descrição de hardware (HDL) usada para modelar os sistemas eletrônicos e processadores em um nível mais próximo do hardware real.

📂 Estrutura do Repositório
Para manter a organização, cada arquitetura terá seu próprio diretório, contendo subpastas para as respectivas implementações em Logisim e Verilog.

/
├── MIPS_Monociclo/
│   ├── logisim/
│   │   └── MIPS_Monociclo.circ
│   └── verilog/
│       └── mips_monociclo.v
│
├── MIPS_Multiciclo/
│   ├── logisim/
│   └── verilog/
│
├── MIPS_Pipeline/
│   ├── logisim/
│   └── verilog/
│
└── VLIW/
    ├── docs/
    └── src/
🚀 Como Utilizar
Projetos em Logisim: Para visualizar e simular os circuitos, abra os arquivos com extensão .circ na versão mais recente do Logisim Evolution.

Projetos em Verilog: Os arquivos .v podem ser compilados e simulados utilizando ferramentas padrão da indústria, como ModelSim, Icarus Verilog, ou Vivado.
