//load mux

module load_mux(
input logic [31:0]adder_out,
input logic [31:0] load_val,
input logic PCSrc,
output logic [31:0] load_mux_out
);
assign load_mux_out=PCSrc ? load_val : adder_out ;

endmodule