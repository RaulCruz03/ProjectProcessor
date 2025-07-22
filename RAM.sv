module RAM #(parameter WIDTH = 32, parameter ADDR_WIDTH = 8)(
    input  logic [ADDR_WIDTH-1:0] addr_ram,
    input  logic MemWrite, MemRead,
    input  logic clk,
    input  logic [WIDTH-1:0] data_ALU,
    output logic [WIDTH-1:0] data
);

logic [WIDTH-1:0] memory [0:(2**ADDR_WIDTH)-1];

always_ff @(posedge clk) begin
    if (MemWrite) 
        memory[addr_ram] <= data_ALU;
end

assign data = (MemRead) ? memory[addr_ram] : {WIDTH{1'bz}};

endmodule
