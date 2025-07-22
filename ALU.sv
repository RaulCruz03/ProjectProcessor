module alu #(parameter WIDTH = 32) ( // Parâmetro WIDTH adicionado para flexibilidade
    input  logic [WIDTH-1:0] a,
    input  logic [WIDTH-1:0] b,
    input  logic [4:0]       shamt_in,
    input  logic [3:0]       alu_sel,
    output logic [WIDTH-1:0] result,
    output logic             zero
);

    always_comb begin
        case (alu_sel)
            4'b0000: result = a + b;                  // add
            4'b0001: result = a - b;                  // sub
            4'b0010: result = a * b;                  // mult
            4'b0011: result = a / b;                  // div 
            4'b0100: result = {WIDTH-1{1'b0}, (a < b)}; // slt 
            4'b0101: result = a | b;                  // or 
            4'b0110: result = a & b;                  // and
            4'b0111: result = a ^ b;                  // xor
            4'b1000: result = ~a;                     // not
            4'b1001: result = b << shamt_in;          // sll
            4'b1010: result = b >> shamt_in;          // srl 
            default: result = {WIDTH{1'bx}};          // default 
        endcase
    end 
    
    assign zero = (result == 0);
    
endmodule