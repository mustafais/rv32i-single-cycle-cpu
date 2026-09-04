module Shift_add(
    input logic [31:0] adder_in,
    input logic [31:0] branch_in,
    output logic [31:0] shift_add_out
);

assign shift_add_out = adder_in + branch_in;



endmodule