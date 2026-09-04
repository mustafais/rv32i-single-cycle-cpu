module PC_src(
    input logic [31:0] rd1,
    input logic [31:0] rd2,
    input logic [2:0]  funct3,
    input logic        Branch,
    input logic        Jump,
    output logic       PCSrc
);

logic branch_taken;

always_comb begin
    case (funct3)
        3'b000: branch_taken = (rd1 == rd2);                    // BEQ
        3'b001: branch_taken = (rd1 != rd2);                    // BNE
        3'b100: branch_taken = ($signed(rd1) < $signed(rd2));   // BLT
        3'b101: branch_taken = ($signed(rd1) >= $signed(rd2));  // BGE
        3'b110: branch_taken = (rd1 < rd2);                     // BLTU
        3'b111: branch_taken = (rd1 >= rd2);                    // BGEU
        default: branch_taken = 1'b0;
    endcase
end

assign PCSrc = (Branch & branch_taken) | Jump;

endmodule
