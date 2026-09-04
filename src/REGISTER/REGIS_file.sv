module Register(
    input logic [4:0] rs1,
    input logic [4:0] rs2,
    input logic [4:0] rd,
    input logic [31:0] write_data,
    input logic reg_write,
    input logic clk,
    output logic [31:0] rd1,
    output logic [31:0] rd2
);

logic [31:0] regs [31:0];

integer i;
initial begin
    for(i = 0; i < 32; i++)
        regs[i] = 32'h0;
end

assign rd1 =(rs1==5'd0) ? 32'd0 : regs[rs1];
assign rd2 =(rs2==5'd0) ? 32'd0 : regs[rs2];

always_ff @(posedge clk) begin
    if(rd!=0 && reg_write) begin
        regs[rd] <=write_data;
    end

end


endmodule