module imem(
input logic [31:0] addr,
output logic [31:0] instruction
);

logic [31:0] memory [0:255];

initial begin 
    $readmemh("program.hex", memory);
end

assign instruction = memory[addr[31:2]];

endmodule