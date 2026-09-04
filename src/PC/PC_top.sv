module PC_top (
    input logic clk,
    input logic reset,
    input logic PCSrc,
    input logic [31:0] load_val,
    output logic [31:0] pc_value,
    output logic [31:0] next_pc
);

    logic [31:0] pc_in_val;

    PC pc_inst (
        .clk(clk),
        .reset(reset),
        .pc_in(pc_in_val),
        .pc_out(pc_value)
    );

    Add4 add4_inst (
        .adder_in(pc_value),
        .adder_out(next_pc)
    );

    load_mux load_mux_inst(
        .adder_out(next_pc),
        .load_val(load_val),
        .PCSrc(PCSrc),
        .load_mux_out(pc_in_val)
    );

endmodule
