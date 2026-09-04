module ALU_op1_mux(
    input logic [31:0] rd1,
    input logic [31:0] pc_value,
    input logic ALU_srcA,
    output logic [31:0] op_field1
);

assign op_field1= ALU_srcA ? pc_value : rd1 ;

endmodule