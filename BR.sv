module BR#(parameter WIDTH = 32, parameter ADDR_WIDTH = 5)(
    input logic clk,reset,we,
    input logic  [ADDR_WIDTH - 1:0] read_addr1,
    input logic  [ADDR_WIDTH - 1:0] read_addr2,
    input logic  [ADDR_WIDTH - 1:0] write_addr,
    input logic  [WIDTH - 1   :  0] data,
    output logic [WIDTH - 1   :  0] read_A,  
    output logic [WIDTH - 1   :  0] read_B  
);
    // Declara 32 registradores de 32 bits cada
    logic [WIDTH-1:0] register [0:(2**ADDR_WIDTH)-1];
    assign read_A = register[read_addr1];
    assign read_B = register[read_addr2];

    always_ff @( posedge clk ) begin 
        if(reset) begin
            for(int i = 0; i < (2**ADDR_WIDTH);i++) begin
                register[i] <= 0;
            end
        end
        else begin
            if (we && (write_addr != 0)) begin
            register[write_addr] <= data;
        end
    end
end

endmodule