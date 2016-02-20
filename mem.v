module mem(wr_data, wr_addr, wr_en, rd0_data, rd1_data, rd0_addr, rd1_addr, clk);
    parameter n=8;
    input [n-1:0] wr_data, wr_addr;
    input wr_en;
    output [n-1:0] rd0_data, rd1_data;
    input [n-1:0] rd0_addr, rd1_addr;
    input clk;

    parameter filename = "addArray.data";

    reg[n-1:0] data [0:255];

    initial $readmemb(filename, data);

    always @(posedge clk)
        if(wr_en) data[wr_addr] <= wr_data;

    assign rd0_data = data[rd0_addr];
    assign rd1_data = data[rd1_addr];

endmodule
