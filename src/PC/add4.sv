module Add4(
    input logic [31:0] adder_in,
    output logic [31:0] adder_out
);
    assign adder_out=adder_in+32'd4;
endmodule