module sll #(parameter WIDTH = 32) (
    input  logic [WIDTH-1:0] data_in,      // O dado a ser deslocado (ex: valor de rt)
    input  logic [4:0]       shamt,        // A quantidade de deslocamento
    output logic [WIDTH-1:0] data_out       // O resultado
);

    // A atribuição 'assign' descreve a conexão direta.
    // O operador '<<' realiza o deslocamento lógico para a esquerda.
    assign data_out = data_in << shamt;

endmodule