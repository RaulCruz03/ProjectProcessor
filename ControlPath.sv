module ControlPath#(parameter WIDTH = 32)(
    input  logic [3:0] opcode;
    output logic [1:0] ALUOp;
    output logic RegDSt,
                 WriteReg,
                 ALUSrc,
                 MemToReg,
                 MemRead,
                 MemWrite,
                 Branch,
                 Jump
);

    always_comb begin
        RegDst   = 1'b0;
        RegWrite = 1'b0;
        ALUSrc   = 1'b0;
        MemtoReg = 1'b0;
        MemRead  = 1'b0;
        MemWrite = 1'b0;
        Branch   = 1'b0;
        Jump     = 1'b0;
        ALUOp    = 2'b00;

        case (opcode)
            4'b0000: begin // Tipo-R
                RegDst   = 1'b1;
                RegWrite = 1'b1;
                ALUSrc   = 1'b1; 
                ALUOp    = 2'b10;
            end
            4'b0001: begin // ld
                WriteReg = 1'b1;
                MemToReg = 1'b1;
                MemRead  = 1'b1;
            end
            4'b0010: begin // st
                MemWrite = 1'b1;
            end
            4'b0011: begin // branch
                ALUSrc = 1'b1;
                ALUop  = 2'b01;
                Branch = 1'b1;
            end
            4'b0101: begin // jump
                Jump   = 1'b1;
            end
        endcase
    end

endmodule
