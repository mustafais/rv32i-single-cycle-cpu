// PC Module

module PC (
    input logic [31:0] pc_in,
    input logic  clk,
    input logic reset,
    output logic [31:0] pc_out
);

//logic [31:0] next_pc;

//assign next_pc=pc_in +32'h00000004;

always_ff @( posedge clk or posedge reset ) begin 
    if (reset)
        begin
            pc_out<= 32'h00000000;
        end

    else  
        begin
            pc_out <= pc_in;
        end
    
end

endmodule 

    