module Mem_Mux(
    input logic [31:0] MemData,
    input logic [31:0] ALU_data,
    input logic MemtoReg,
    output logic [31:0] RegData
);

assign RegData=MemtoReg ? MemData : ALU_data ;

endmodule