module CPU(
    input  logic        clk,
    input  logic        reset,

    // External instruction-memory interface
    output logic [31:0] imem_addr,
    input  logic [31:0] instruction,

    // External data-memory interface
    output logic [31:0] dmem_addr,
    output logic [31:0] dmem_write_data,
    output logic        dmem_write_en,
    output logic        dmem_read_en,
    input  logic [31:0] dmem_read_data,

    // Optional debug output
    output logic [31:0] imem_value
);

// PC
logic [31:0] pc_value, next_pc, load_val;
logic        PCSrc;

// Instruction fields
logic [6:0]  opcode;
logic [4:0]  rs1_addr, rs2_addr, rd_addr;
logic [2:0]  funct3;
logic [6:0]  funct7;
logic [3:0]  funct;

// Control signals
logic        ALU_src, ALU_srcA, Mem_to_Reg, Reg_Write;
logic        Mem_Read, Mem_Write, Branch, Jump, jalr;
logic [1:0]  ALU_op_src;
logic [2:0]  imm_src;

// Datapath
logic [31:0] imm_out;
logic [31:0] rd1, rd2;
logic [31:0] alu_op2, op_field1;
logic [3:0]  ALU_op;
logic [31:0] ALU_result;
logic        out_zero, negative, overflow, carry;
logic [31:0] ReadData;
logic [31:0] RegData;
logic [31:0] write_data;
logic [31:0] shift_add_out;


// External memory connections
assign imem_addr       = pc_value;

assign dmem_addr       = ALU_result;
assign dmem_write_data = rd2;
assign dmem_write_en   = Mem_Write;
assign dmem_read_en    = Mem_Read;

assign ReadData = dmem_read_data;


// Instruction field slicing
assign opcode   = instruction[6:0];
assign rd_addr  = instruction[11:7];
assign funct3   = instruction[14:12];
assign rs1_addr = instruction[19:15];
assign rs2_addr = instruction[24:20];
assign funct7   = instruction[31:25];
assign funct    = {funct7[5], funct3};


// PC
PC_top PC_1(
    .clk(clk),
    .reset(reset),
    .PCSrc(PCSrc),
    .load_val(load_val),
    .pc_value(pc_value),
    .next_pc(next_pc)
);


// Control unit
control_unit control_unit_1 (
    .opcode(opcode),
    .ALU_src(ALU_src),
    .ALU_srcA(ALU_srcA),
    .Mem_to_Reg(Mem_to_Reg),
    .Reg_Write(Reg_Write),
    .Mem_Read(Mem_Read),
    .Mem_Write(Mem_Write),
    .Branch(Branch),
    .ALU_op_src(ALU_op_src),
    .imm_src(imm_src),
    .Jump(Jump),
    .jalr(jalr)
);


// Immediate generator
imed imed_1(
    .imed_in(instruction),
    .imm_src(imm_src),
    .imed_out(imm_out)
);


// Register file
Register register_1 (
    .clk(clk),
    .rs1(rs1_addr),
    .rs2(rs2_addr),
    .rd(rd_addr),
    .write_data(write_data),
    .reg_write(Reg_Write),
    .rd1(rd1),
    .rd2(rd2)
);


// ALU control
ALU_control_unit ALU_control_unit_1(
    .ALU_op_src(ALU_op_src),
    .funct(funct),
    .ALU_op(ALU_op)
);


// ALU operand muxes
assign alu_op2 = ALU_src ? imm_out : rd2;

ALU_op1_mux ALU_op1_mux_1(
    .rd1(rd1),
    .pc_value(pc_value),
    .ALU_srcA(ALU_srcA),
    .op_field1(op_field1)
);


// ALU
ALU ALU_1(
    .op_field1(op_field1),
    .op_field2(alu_op2),
    .ALU_op(ALU_op),
    .ALU_result(ALU_result),
    .out_zero(out_zero),
    .negative(negative),
    .overflow(overflow),
    .carry(carry)
);


// Branch / jump target
Shift_add Shift_add_1(
    .adder_in(pc_value),
    .branch_in(imm_out),
    .shift_add_out(shift_add_out)
);

jalr_mux jalr_mux_1(
    .shift_add_out(shift_add_out),
    .ALU_result(ALU_result),
    .jalr(jalr),
    .load_val(load_val)
);


// Direct branch comparison
PC_src PC_src_1(
    .rd1(rd1),
    .rd2(rd2),
    .funct3(funct3),
    .Branch(Branch),
    .Jump(Jump),
    .PCSrc(PCSrc)
);


// Memory / ALU writeback selection
Mem_Mux Mem_Mux_1(
    .MemData(ReadData),
    .ALU_data(ALU_result),
    .MemtoReg(Mem_to_Reg),
    .RegData(RegData)
);


// Jump writeback selection
jump_mux jump_mux_1(
    .RegData(RegData),
    .next_pc(next_pc),
    .jump(Jump),
    .write_data(write_data)
);


assign imem_value = instruction;

endmodule
