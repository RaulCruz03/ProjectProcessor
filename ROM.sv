module ROM #(parameter WIDTH = 32, parameter ADDR_WIDTH = 8)(
    input  logic [ADDR_WIDTH-1:0] addr_rom,
    output logic [WIDTH-1:0]      instruction
);

logic [WIDTH-1:0] memory [0:(2**ADDR_WIDTH)-1];

    // 2. Carregamento inicial do programa (APENAS PARA SIMULAÇÃO)
    //    Este bloco é executado uma única vez no início da simulação.
    initial begin
        // $readmemh lê um arquivo de texto com números hexadecimais
        // e os carrega para dentro do nosso array 'memory'.
        $readmemh("programa.hex", memory);
    end

    assign instruction = memory[addr_rom];

endmodule