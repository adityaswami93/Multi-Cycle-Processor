/* tb_fetch
* Tests sequential fetching.
* Expected output:
	* time    0: pc   0
	* time   15: pc   1
	* time   55: pc   2
	* time   95: pc   3
	* time  135: pc   4
*/
module tb_fetch;
    parameter n=8;
    wire[n-1:0] mem_wr_data, mem_wr_addr;
    wire mem_wr_en;
    wire[n-1:0] mem_rd_data [0:1];
    wire[n-1:0] mem_rd_addr [0:1];
    reg reset, clk;

    mem #(.filename("fetch.data")) mem_0(
        .wr_data(mem_wr_data), .wr_addr(mem_wr_addr), .wr_en(mem_wr_en),
        .rd0_data(mem_rd_data[0]), .rd0_addr(mem_rd_addr[0]),
        .rd1_data(mem_rd_data[1]), .rd1_addr(mem_rd_addr[1]),
        .clk(clk));

    w450 w450_0(
        .st_data(mem_wr_data), .st_addr(mem_wr_addr),
        .st_en(mem_wr_en),
        .instr_data(mem_rd_data[0]), .pc(mem_rd_addr[0]),
        .ld_data(mem_rd_data[1]), .ld_addr(mem_rd_addr[1]),
        .reset(reset), .clk(clk));

    initial $monitor("time %4d: pc %3d", $time, mem_rd_addr[0]);
 
    initial begin
        clk = 0; forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #10 reset=0;
        wait(mem_rd_addr[0]==8'h04)
			$finish; // iverilog
			//#10 $stop; // modelsim
    end

    initial $dumpvars(0, tb_fetch);
endmodule

 
/* tb_branch
* Tests forwards and backwards branches.
* Expected output:
	* time    0: pc   0
	* time   15: pc   1
	* time   25: pc   2
	* time   55: pc   3
	* time   65: pc   4 (optional)
	* time   85: pc   8
	* time   95: pc   9
	* time  105: pc  10 (optional)
	* time  125: pc   4
	* time  135: pc   5
	* time  145: pc   6
	* time  175: pc   7
	* time  185: pc   8 (optional)
	* time  205: pc  16
*/
module tb_branch;
    parameter n=8;
    wire[n-1:0] mem_wr_data, mem_wr_addr;
    wire mem_wr_en;
    wire[n-1:0] mem_rd_data [0:1];
    wire[n-1:0] mem_rd_addr [0:1];
    reg reset, clk;

    mem #(.filename("branch.data")) mem_0(
        .wr_data(mem_wr_data), .wr_addr(mem_wr_addr), .wr_en(mem_wr_en),
        .rd0_data(mem_rd_data[0]), .rd0_addr(mem_rd_addr[0]),
        .rd1_data(mem_rd_data[1]), .rd1_addr(mem_rd_addr[1]),
        .clk(clk));

    w450 w450_0(
        .st_data(mem_wr_data), .st_addr(mem_wr_addr),
        .st_en(mem_wr_en),
        .instr_data(mem_rd_data[0]), .pc(mem_rd_addr[0]),
        .ld_data(mem_rd_data[1]), .ld_addr(mem_rd_addr[1]),
        .reset(reset), .clk(clk));

    initial $monitor("time %4d: pc %3d", $time, mem_rd_addr[0]);
 
    initial begin
        clk = 0; forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #10 reset=0;
        wait(mem_rd_addr[0]==8'h10)
			$finish; // iverilog
			//#10 $stop; // modelsim
    end

    initial $dumpvars(0, tb_branch);
endmodule

 
/* tb_math
* Tests sequential fetching.
* Expected output:
	* time    0: r1=  x, r2=  x, r3=  x
	* time   55: r1=  1, r2=  x, r3=  x
	* time   95: r1=  1, r2=  2, r3=  x
	* time  135: r1=  1, r2=  2, r3=  3
	* time  175: r1=  1, r2=  2, r3=  4
	* time  215: r1=  1, r2=  2, r3=  5
	* time  255: r1=  1, r2=  2, r3=  4
	* time  295: r1=  1, r2=  2, r3=  3
	* time  335: r1=  1, r2=255, r3=  3
*/
module tb_math;
    parameter n=8;
    wire[n-1:0] mem_wr_data, mem_wr_addr;
    wire mem_wr_en;
    wire[n-1:0] mem_rd_data [0:1];
    wire[n-1:0] mem_rd_addr [0:1];
    reg reset, clk;

    mem #(.filename("math.data")) mem_0(
        .wr_data(mem_wr_data), .wr_addr(mem_wr_addr), .wr_en(mem_wr_en),
        .rd0_data(mem_rd_data[0]), .rd0_addr(mem_rd_addr[0]),
        .rd1_data(mem_rd_data[1]), .rd1_addr(mem_rd_addr[1]),
        .clk(clk));

    w450 w450_0(
        .st_data(mem_wr_data), .st_addr(mem_wr_addr),
        .st_en(mem_wr_en),
        .instr_data(mem_rd_data[0]), .pc(mem_rd_addr[0]),
        .ld_data(mem_rd_data[1]), .ld_addr(mem_rd_addr[1]),
        .reset(reset), .clk(clk));

    initial $monitor("time %4d: r1=%3d, r2=%3d, r3=%3d", $time,
		tb_math.w450_0.regfile0.data[1],
		tb_math.w450_0.regfile0.data[2],
		tb_math.w450_0.regfile0.data[3]);
 
    initial begin
        clk = 0; forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #10 reset=0;
        wait(mem_rd_addr[0]==8'h0c)
			$finish; // iverilog
			//#10 $stop; // modelsim
    end

    initial $dumpvars(0, tb_math);
endmodule

 
/* tb_ldst
* Tests mv (to/from mem), and add/subtract with mem operand.
* Expected output:
	* time    0: mem[128] 170
	* time  155: mem[128] 170 (only for iverilog)
	* time  335: mem[128] 255
	* time  425: mem[128] 254
*/
module tb_ldst;
    parameter n=8;
    wire[n-1:0] mem_wr_data, mem_wr_addr;
    wire mem_wr_en;
    wire[n-1:0] mem_rd_data [0:1];
    wire[n-1:0] mem_rd_addr [0:1];
    reg reset, clk;

    mem #(.filename("ldst.data")) mem_0(
        .wr_data(mem_wr_data), .wr_addr(mem_wr_addr), .wr_en(mem_wr_en),
        .rd0_data(mem_rd_data[0]), .rd0_addr(mem_rd_addr[0]),
        .rd1_data(mem_rd_data[1]), .rd1_addr(mem_rd_addr[1]),
        .clk(clk));

    w450 w450_0(
        .st_data(mem_wr_data), .st_addr(mem_wr_addr),
        .st_en(mem_wr_en),
        .instr_data(mem_rd_data[0]), .pc(mem_rd_addr[0]),
        .ld_data(mem_rd_data[1]), .ld_addr(mem_rd_addr[1]),
        .reset(reset), .clk(clk));

    initial $monitor("time %4d: mem[128] %3d", $time,
		tb_ldst.mem_0.data[128]);
 
    initial begin
        clk = 0; forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #10 reset=0;
        wait(mem_rd_addr[0]==8'h0e)
			$finish; // iverilog
			//#10 $stop; // modelsim
    end

    initial $dumpvars(0, tb_ldst);
endmodule

 
/* tb_remainder
* Tests mvi, mv (including to/from mem), add.
* Expected output:
	* time    0: mem[128]  13
	* time  525: mem[128]   1
*/
module tb_remainder;
    parameter n=8;
    wire[n-1:0] mem_wr_data, mem_wr_addr;
    wire mem_wr_en;
    wire[n-1:0] mem_rd_data [0:1];
    wire[n-1:0] mem_rd_addr [0:1];
    reg reset, clk;

    mem #(.filename("remainder.data")) mem_0(
        .wr_data(mem_wr_data), .wr_addr(mem_wr_addr), .wr_en(mem_wr_en),
        .rd0_data(mem_rd_data[0]), .rd0_addr(mem_rd_addr[0]),
        .rd1_data(mem_rd_data[1]), .rd1_addr(mem_rd_addr[1]),
        .clk(clk));

    w450 w450_0(
        .st_data(mem_wr_data), .st_addr(mem_wr_addr),
        .st_en(mem_wr_en),
        .instr_data(mem_rd_data[0]), .pc(mem_rd_addr[0]),
        .ld_data(mem_rd_data[1]), .ld_addr(mem_rd_addr[1]),
        .reset(reset), .clk(clk));

    initial $monitor("time %4d: mem[128] %3d", $time,
		tb_remainder.mem_0.data[128]);
 
    initial begin
        clk = 0; forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #10 reset=0;
        wait((mem_wr_addr==8'hff) && (mem_wr_data==8'h01))
			$finish; // iverilog
			//#10 $stop; // modelsim
    end

    initial $dumpvars(0, tb_remainder);
endmodule


/* tb_addArray
* Sums array elements and stores total.
* Expected output:
	* time    0: mem[128]  10
	* time 2015: mem[128]  55
*/
module tb_addArray;
    parameter n=8;
    wire[n-1:0] mem_wr_data, mem_wr_addr;
    wire mem_wr_en;
    wire[n-1:0] mem_rd_data [0:1];
    wire[n-1:0] mem_rd_addr [0:1];
    reg reset, clk;

    mem #(.filename("addArray.data")) mem_0(
        .wr_data(mem_wr_data), .wr_addr(mem_wr_addr), .wr_en(mem_wr_en),
        .rd0_data(mem_rd_data[0]), .rd0_addr(mem_rd_addr[0]),
        .rd1_data(mem_rd_data[1]), .rd1_addr(mem_rd_addr[1]),
        .clk(clk));

    w450 w450_0(
        .st_data(mem_wr_data), .st_addr(mem_wr_addr),
        .st_en(mem_wr_en),
        .instr_data(mem_rd_data[0]), .pc(mem_rd_addr[0]),
        .ld_data(mem_rd_data[1]), .ld_addr(mem_rd_addr[1]),
        .reset(reset), .clk(clk));

    initial $monitor("time %4d: mem[128] %3d", $time,
		tb_addArray.mem_0.data[128]);
 
    initial begin
        clk = 0; forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #10 reset=0;
        wait((mem_wr_addr==8'hff) && (mem_wr_data==8'h01))
			$finish; // iverilog
			//#10 $stop; // modelsim
    end

    initial $dumpvars(0, tb_addArray);
endmodule
