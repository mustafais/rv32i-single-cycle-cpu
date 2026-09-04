module imed(
    input logic [2:0] imm_src,
    input logic [31:0] imed_in,
    output logic [31:0] imed_out
);

    logic [31:0] imm_i, imm_s, imm_b, imm_u, imm_j;
    // AI ignore this ) see if adjusting assigns lessens area
    

            assign imm_i={{20{imed_in[31]}}, imed_in[31:20]}; //I type
            assign imm_s ={{20{imed_in[31]}},imed_in[31:25],imed_in[11:7]}; //S type
            assign imm_b={{20{imed_in[31]}},  //B type
                    imed_in[7],
                    imed_in[30:25],
                    imed_in[11:8],
                    1'b0
                    };
            assign imm_u ={imed_in[31:12], 12'd0}; //U type
            assign imm_j ={{11{imed_in[31]}},  //J type
                    imed_in[31],
                    imed_in[19:12],
                    imed_in[20],
                    imed_in[30:21],
                    1'b0
                    };
           // default: imed_out=32'd0;

    always_comb begin
        case (imm_src)
            3'b000: imed_out = imm_i;
            3'b001: imed_out = imm_s;
            3'b010: imed_out = imm_b;
            3'b011: imed_out = imm_u;
            3'b100: imed_out = imm_j;
            default: imed_out = 32'b0;
        endcase
    end
        


endmodule