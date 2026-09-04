module ALU_control_unit(
    input logic [1:0] ALU_op_src,
    input logic [3:0] funct,
    output logic [3:0] ALU_op
);

logic [2:0] funct3;
logic funct7;

always @(*) begin
    funct3 = funct[2:0];
    funct7 = funct[3];
    
    case (ALU_op_src)
        2'b00: begin //S type , I type load, J type, U type
                ALU_op = 4'b0000;
                end
        2'b01: begin //B type Branch
                ALU_op = 4'b0001;
                end
        2'b10: begin //R type

                if(funct3==3'b111) // and
                begin
                    ALU_op = 4'b0010;
                end
                else if(funct3==3'b110) // or
                begin
                    ALU_op = 4'b0011;
                end
                else if(funct3==3'b100) //xor
                begin
                    ALU_op=4'b0100;
                end
                else if(funct3==3'b010) //slt
                begin
                    ALU_op=4'b0101;
                end
                else if(funct3==3'b011) //sltu
                begin
                    ALU_op=4'b0110;
                end
                else if(funct3==3'b001) //SLL
                begin
                    ALU_op = 4'b0111;
                end
                else if(funct3==3'b101 & funct7==0) //SRL
                begin
                    ALU_op = 4'b1000;
                end
                else if(funct3==3'b101 & funct7==1) //SRA
                begin
                    ALU_op = 4'b1001;
                end
                else if(funct3==3'b000 & funct7==1) //sub
                begin
                    ALU_op = 4'b0001;
                end
                else if(funct3==3'b000) // add
                begin
                    ALU_op = 4'b0000;
                end
                else ALU_op=4'b0000;
                end
        2'b11: begin //I type immediate
                    if     (funct3==3'b111) ALU_op = 4'b0010; // ANDI
                    else if(funct3==3'b110) ALU_op = 4'b0011; // ORI
                    else if(funct3==3'b100) ALU_op = 4'b0100; // XORI
                    else if(funct3==3'b010) ALU_op = 4'b0101; // SLTI
                    else if(funct3==3'b011) ALU_op = 4'b0110; // SLTIU
                    else if(funct3==3'b001) ALU_op = 4'b0111; // SLLI
                    else if(funct3==3'b101 && funct7==1) ALU_op = 4'b1001; // SRAI
                    else if(funct3==3'b101) ALU_op = 4'b1000; // SRLI
                    else ALU_op = 4'b0000; // ADDI (funct3=000, always add)
                end
                default: ALU_op = 4'b0000;
    endcase
end
endmodule