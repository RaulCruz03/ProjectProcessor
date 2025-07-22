module Datapath #(parameter WIDTH = 32, parameter REG_WIDTH   = 5,
           parameter OFFSET_WIDTH = 18, parameter SHAMT_WIDTH = 5,
           parameter  FUNCT_WIDTH = 8 , parameter ADDR_WIDTH  = 8)(
    // Entrada de sinais de controle
    input logic RegDst, WriteReg, ALUSrc, MemToReg, MemRead,
    input logic MemWrite, Branch, Jump,
    input logic [1:0] ALUop,
    // Sinais universais
    input logic  clk, reset,

    output logic [3:0] opcode,
    output logic [4:0] funct,
    output logic zero_flag
);

//======================================================================
// Etapa 1: Busca da Instrução (IF)
//======================================================================
    logic [WIDTH-1:0] w_pc_current, w_pc_next, w_pc_plus_4;
    logic [WIDTH-1:0] instruction;

    // O PC (Program Counter)
    register #(WIDTH) pc_reg(
        .clk(clk), .reset(reset), .we(1'b1), 
        .d(w_pc_next), .q(w_pc_current)
    );

    // ROM de Instrução
    instruction_rom #(.WIDTH(WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) rom_inst(
        .addr(w_pc_current[ADDR_WIDTH+1:2]),
        .instruction(instruction)  
    );

    // Somador para PC+4
    adder sum_pcp4(
        .a(w_pc_current), .b(32'd4), .s(w_pc_plus_4)
    );

//======================================================================
// Etapa 2: Decodificação (ID)
//======================================================================
    logic [WIDTH-1:0] w_read_data_1, w_read_data_2, w_write_back_data;
    logic [4:0]       w_addr_rs, w_addr_rt, w_addr_rd, w_final_write_addr;
    logic [OFFSET_WIDTH-1:0] w_offset;
    logic [SHAMT_WIDTH-1:0] w_shamt;
    logic [FUNCT_WIDTH-1:0] w_funct;
    logic  [WIDTH-1:0] w_extended_offset;

    // Extrai os campos de endereço de registrador por suas POSIÇÕES FIXAS
    assign opcode      = instruction[31:28];
    assign w_addr_rd   = instruction[27:23]; // Campo usado para rd (Tipo-R) ou rs (Tipo-I)
    assign w_addr_rs   = instruction[22:18]; // Campo usado para rs (Tipo-R) ou rt (Tipo-I)
    assign w_addr_rt   = instruction[17:13]; // Campo usado para rt (Tipo-R)
    assign w_shamt     = instruction[12:8];
    assign w_funct     = instruction[7:0];
    assign w_offset    = instruction[17:0];       // Para Tipo-I
    assign w_extended_offset = {{14{instruction[17]}}, instruction[17:0]};
    
    // MUX para selecionar o registrador de destino (rd ou rt)
    mux #(.WIDTH(REG_WIDTH)) regdst_mux (
        .sel(RegDst),
        .d1(w_addr_rs), // Se RegDst=0 (Tipo-I), o destino é 'rt' (que está na posição de rs)
        .d2(w_addr_rd), // Se RegDst=1 (Tipo-R), o destino é 'rd'
        .q(w_final_write_addr)
    );
    
    // Banco de Registradores
    BR #(.WIDTH(WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) br_datapath (
        .clk(clk),
        .reset(reset),
        .we(WriteReg),                  
        .read_addr1(w_addr_rd),        
        .read_addr2(w_addr_rs),         
        .write_addr(w_final_write_addr),
        .data(w_write_back_data),       
        .read_A(w_read_data_1),
        .read_B(w_read_data_2)
    );

//======================================================================
// Etapa 3: Execução (Execute)
//======================================================================
    
    logic w_zero, w_or_branch;
    logic [WIDTH-1:0] w_alu_input_b, w_shifted_offset, w_alu_exit, w_pc_plus_branch, w_branch_or_inc;
    logic [3:0] w_alu_selector;
    assign w_shifted_offset = w_extended_offset << 2;
    assign w_pc_plus_branch = w_pc_plus_4 + w_shifted_offset;
    

    assign w_alu_input_b = (ALUSrc) ? w_read_data_2 : w_extended_offset;

    ALU_control uc_ula(
        .ALUOp_in(ALUop), .funct_in(w_funct), .ALUSelection(w_alu_selector)
    );

    ALU #(.WIDTH(WIDTH)) alu( 
        .a(w_read_data_1), .b(ww_alu_input_b), .shamt_in(w_shamt), .alu_sel(w_alu_selector), .result(w_alu_exit), .zero(w_zero)
    );

    assign w_branch_taken = w_zero & Branch;

    mux branch_mux(
        .sel(w_branch_taken), .d1(w_pc_plus_4), .d2(w_pc_plus_branch), .q(w_branch_or_inc)
    );


//======================================================================
// Etapa 4: Memoria
//======================================================================

    logic [7:0] w_addr_ram;
    logic [WIDTH-1 : 0] w_ram_exit, w_jump;

    assign w_jump = {w_pc_plus_4[31:28], instruction[27:0]};
    assign w_addr_ram = w_alu_exit[9:2];

RAM #(.WIDTH(WIDTH),.ADDR_WIDTH(ADDR_WIDTH)) ram_dp (
    .addr_ram(w_addr_ram), .MemWrite(MemWrite), .MemRead(MemRead), .clk(clk), .data_ALU(w_read_data_2), .data(w_ram_exit)
);


//======================================================================
// Etapa 5: Escrita
//======================================================================

mux #(.WIDTH(WIDTH)) pc_mux (
        .sel(Jump),
        .d1(w_branch_or_inc), 
        .d2(w_jump), 
        .q(w_pc_next)
    );

mux #(.WIDTH(WIDTH)) w_BR(
        .sel(MemToReg), .d1(w_alu_exit), .d2(w_ram_exit), .q(w_write_back_data)
);



    
endmodule