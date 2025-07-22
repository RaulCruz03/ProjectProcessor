module main (
    input logic clk,
    input logic reset
);



    logic [3:0] w_opcode;
    logic       w_reg_dst, w_write_reg, w_alusrc, w_mem_to_reg;
    logic       w_mem_read, w_mem_write, w_branch, w_jump;
    logic [1:0] w_alu_op;
    
    Datapath #() datapath_inst (
        .clk(clk),
        .reset(reset),
        .RegDst(w_reg_dst),
        .WriteReg(w_write_reg),
        .ALUSrc(w_alusrc),
        .MemToReg(w_mem_to_reg),
        .MemRead(w_mem_read),
        .MemWrite(w_mem_write),
        .Branch(w_branch),
        .Jump(w_jump),
        .ALUop(w_alu_op),
        .opcode(w_opcode)
    );

    ControlPath #() control_inst (
        .opcode(w_opcode),
        .RegDst(w_reg_dst),
        .WriteReg(w_write_reg),
        .ALUSrc(w_alusrc),
        .MemToReg(w_mem_to_reg),
        .MemRead(w_mem_read),
        .MemWrite(w_mem_write),
        .Branch(w_branch),
        .Jump(w_jump),
        .ALUOp(w_alu_op)
    );

endmodule