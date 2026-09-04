module jump_mux(
    input logic [31:0] RegData,
    input logic [31:0] next_pc,
    input logic jump,
    output logic[31:0] write_data
);

assign write_data = jump ? next_pc : RegData;

endmodule