module control_unit(
    input logic [6:0] opcode,
    output logic ALU_src,
    output logic ALU_srcA,
    output logic Mem_to_Reg, //mux control
    output logic Reg_Write,
    output logic Mem_Read,
    output logic Mem_Write, //control read/writes in reg file and data memory
    output logic Branch,
    output logic [1:0] ALU_op_src,
    output logic [2:0] imm_src,
    output logic Jump,
    output logic jalr
);


always_comb begin 
    //------Default Values ---------------
    ALU_src=0;
    ALU_srcA=0;
    Mem_to_Reg=0;
    Reg_Write=0;
    Mem_Read=0;
    Mem_Write=0;
    Branch=0;
    ALU_op_src=2'b00;
    imm_src=3'b000;
    Jump=0;
    jalr=0;

    case (opcode)
        7'b0110011: begin//R type arithmetic and logic operators
                    Reg_Write=1;
                    //ALU_src=0;
                    ALU_op_src=2'b10;
                    end
        7'b0010011: begin //I type (immediates)
                    ALU_src=1;
                    Reg_Write=1;
                    imm_src=3'b000;
                    ALU_op_src=2'b11;
                    end
        7'b0000011: begin //I type (load)
                    ALU_src=1;
                    Mem_Read=1;
                    Mem_to_Reg=1;
                    Reg_Write=1;
                    ALU_op_src=2'b00;
                    imm_src=3'b000;
                    end
        7'b0100011: begin //S type store data in memory
                    Mem_Write=1;
                    ALU_src=1;
                    ALU_op_src=2'b00;
                    imm_src=3'b001;
                    end
        7'b1100011: begin //B type  conditional branch
                    ALU_op_src=2'b01;
                    Branch=1;
                    imm_src=3'b010;
                    end
        7'b1101111: begin //J type unconditiional jump and link
                    Reg_Write=1;
                    imm_src=3'b100;
                    Jump=1;
                    end
        7'b1100111: begin //JALR
                    ALU_src=1;
                    Jump=1;
                    Reg_Write=1;
                    imm_src=3'b000;
                    jalr=1;
                    end
        7'b0110111: begin // U type load upper immediate
                    Reg_Write=1;
                    imm_src=3'b011;
                    ALU_src = 1;

                    end
        7'b0010111: begin // U type add upper immediate
                    Reg_Write=1;
                    imm_src=3'b011;
                    ALU_op_src=2'b00;
                    ALU_src=1;
                    ALU_srcA=1;
                    end


    endcase
end


endmodule