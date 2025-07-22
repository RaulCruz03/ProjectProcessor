module mux #(parameter WIDTH = 32)(
    logic input sel,
    logic input  [WIDTH-1:0] d1,d2,
    logic output [WIDTH-1:0] q
);

assign q = (sel == 1'b0) ? d1:d2; 

endmodule