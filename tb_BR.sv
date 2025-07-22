// BR_tb.v
// Testbench para o Banco de Registradores (BR)

module BR_tb;

    // 1. Declaração dos Parâmetros e Sinais
    // Parâmetros devem ser idênticos aos do módulo que estamos testando.
    parameter WIDTH = 32;
    parameter ADDR_WIDTH = 5;
    parameter CLK_PERIOD = 10; // Período do clock em unidades de tempo (ex: 10 ns)

    // Sinais para conectar ao nosso BR.
    logic                  clk;
    logic                  reset;
    logic                  we; // Write Enable
    logic [ADDR_WIDTH-1:0] read_addr1, read_addr2, write_addr;
    logic [WIDTH-1:0]      write_data;
    logic [WIDTH-1:0]      read_A, read_B;

    // 2. Instanciação do Módulo a ser Testado (Device Under Test - DUT)
    // Conectamos os nossos sinais locais às portas do módulo BR.
    BR #(
        .WIDTH(WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .we(we),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .write_addr(write_addr),
        .data(write_data),
        .read_A(read_A),
        .read_B(read_B)
    );

    // 3. Geração do Clock
    // Este bloco 'always' gera um sinal de clock que inverte a cada 5 unidades de tempo.
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // 4. O Cenário de Teste
    // O bloco 'initial' é executado apenas uma vez, no início da simulação.
    initial begin
        $display("Iniciando simulação do Banco de Registradores...");

        // Pulso de Reset Inicial
        reset = 1;
        we = 0; // Boa prática manter o write desabilitado durante o reset
        #20; // Espera 20 unidades de tempo
        reset = 0;
        $display("Reset liberado.");

        // --- TESTE 1: Escrita no Registrador 5 ---
        $display("\n--- Teste 1: Escrevendo 123 em $r5 ---");
        write_addr = 5;
        write_data = 123;
        we = 1;         // Habilita a escrita
        @(posedge clk); // Espera a próxima borda de subida do clock
        we = 0;         // Desabilita a escrita (boa prática)
        
        // --- TESTE 2: Leitura do Registrador 5 ---
        $display("\n--- Teste 2: Lendo de $r5 ---");
        read_addr1 = 5;
        #5; // Espera um pouco para o valor se propagar na leitura
        if (read_A == 123)
            $display("SUCESSO! Valor lido de $r5: %d", read_A);
        else
            $display("FALHA! Valor esperado: 123, Valor lido: %d", read_A);

        // --- TESTE 3: Escrita em outro Registrador ---
        $display("\n--- Teste 3: Escrevendo 456 em $r10 ---");
        write_addr = 10;
        write_data = 456;
        we = 1;
        @(posedge clk);
        we = 0;

        // --- TESTE 4: Leitura de dois registradores ao mesmo tempo ---
        $display("\n--- Teste 4: Lendo $r5 e $r10 simultaneamente ---");
        read_addr1 = 5;
        read_addr2 = 10;
        #5;
        $display("Valor lido de $r5 (read_A): %d", read_A);
        $display("Valor lido de $r10 (read_B): %d", read_B);
        if (read_A == 123 && read_B == 456)
            $display("SUCESSO! Leitura simultânea correta.");
        else
            $display("FALHA! Leitura simultânea incorreta.");
            
        // --- TESTE 5: Tentativa de escrita no Registrador Zero ---
        $display("\n--- Teste 5: Tentando escrever 999 em $r0 ---");
        write_addr = 0;
        write_data = 999;
        we = 1;
        @(posedge clk);
        we = 0;
        
        read_addr1 = 0;
        #5;
        if (read_A == 0)
            $display("SUCESSO! $r0 permaneceu 0.");
        else
            $display("FALHA! $r0 foi modificado para %d.", read_A);

        $display("\nSimulação concluída.");
        $finish; // Termina a simulação
    end

        initial begin
        // --- Comandos para gerar a waveform ---
        $dumpfile("br_waveform.vcd"); // 1. Define o nome do arquivo de gravação
        $dumpvars(0, dut);            // 2. Diz para gravar TODOS os sinais dentro do 'dut'

        // O resto do seu código de teste continua normalmente
        $display("Iniciando simulação do Banco de Registradores...");
        reset = 1;
        // ... etc ...
    end

endmodule