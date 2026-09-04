module MEM(
    input logic [31:0] addr,
    input logic [31:0] WriteData,
    input logic MemWrite,
    input logic MemRead,
    input logic clk,
    output logic [31:0] ReadData
);

logic [31:0] memory [0:511];

initial begin 
    $readmemh("memory.hex", memory);
end

assign ReadData = memory[addr[31:2]];

always_ff @(posedge clk) begin
    if(MemWrite == 1)
    begin
        memory[addr[31:2]]<=WriteData;
    end

end

endmodule