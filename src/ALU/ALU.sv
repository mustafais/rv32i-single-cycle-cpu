module ALU(
input logic [31:0] op_field1,
input logic [31:0] op_field2,
input logic [3:0] ALU_op, //3 bits for simple alu for now , *adjusted
output logic out_zero,
output logic negative,
output logic overflow,
output logic carry,
output logic [31:0] ALU_result
);

always @(*) begin
    logic [32:0] temp;

    temp=0;
    overflow = 0;
    carry = 0;
    out_zero = 0;
    negative = 0;

    case(ALU_op)
        4'b0000: begin //add
                    temp = {1'b0, op_field1} + {1'b0, op_field2};
                    ALU_result = temp[31:0];
                    carry = temp[32];
                end
        4'b0001: begin //sub
                        temp = {1'b0, op_field1} - {1'b0, op_field2};
                        ALU_result = temp[31:0];
                        carry = temp[32]; // borrow flag for unsigned comparison
                        overflow = (op_field1[31] != op_field2[31]) && (ALU_result[31] != op_field1[31]); end //potentially solvable using shifters
        4'b0010: ALU_result=op_field1 & op_field2; //and
        4'b0011: ALU_result=op_field1 | op_field2; //or
        4'b0100: ALU_result=op_field1 ^ op_field2; //xor
        4'b0101: ALU_result= (($signed(op_field1)) < ($signed(op_field2))) ? 32'd1 : 32'd0; //slt
        4'b0110: ALU_result= op_field1 < op_field2 ? 32'd1 : 32'd0; //sltu
        4'b0111: ALU_result= op_field1 << op_field2[4:0]; //sll
        4'b1000: ALU_result= op_field1 >> op_field2[4:0]; //srl
        4'b1001: ALU_result = $signed(op_field1) >>> op_field2[4:0]; // sra
        default: ALU_result = 32'b0;
    endcase
    if(ALU_result==0)begin
        out_zero=1'd1;
    end
    else begin
        out_zero=1'd0;
    end
    negative = ALU_result[31];
end


endmodule