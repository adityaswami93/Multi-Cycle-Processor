module regfile(wr_data, wr_num, wr_en, rd0_data, rd1_data, rd0_num, rd1_num, clk);
    parameter n=8;
    input [n-1:0] wr_data;
    input [1:0] wr_num;
    input wr_en;
    output [n-1:0] rd0_data, rd1_data;
    input [1:0] rd0_num, rd1_num;
    input clk;

    reg[n-1:0] data [0:3]; // general-purpose registers r0-r3

    always @(posedge clk)
        if(wr_en) data[wr_num] <= wr_data;

    assign rd0_data = data[rd0_num];
    assign rd1_data = data[rd1_num];

endmodule
