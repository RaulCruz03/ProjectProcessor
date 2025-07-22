module register #(parameter WIDTH = 32)(
    input  logic clk,reset,we,
    input  logic [WIDTH-1:0] d,
    output logic [WIDTH-1:0] q  
);

always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
        q <= {WIDTH{1'b0}};
    end
    else if (we) begin
        q <= d;
    end
end

endmodule
