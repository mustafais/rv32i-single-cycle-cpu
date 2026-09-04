module jalr_mux(
    input logic [31:0] shift_add_out,  // PC + imm
    input logic [31:0] ALU_result,     // rs1 + imm
    input logic jalr,
    output logic [31:0] load_val
);
assign load_val = jalr ? {ALU_result[31:1], 1'b0} : shift_add_out;
endmodule