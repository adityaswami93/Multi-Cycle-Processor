module w450(st_data, st_addr, st_en, pc, instr_data, ld_addr, ld_data, reset, clk);
    parameter n=8;
    output reg[n-1:0] st_data, st_addr;
    output reg st_en;
    output reg[n-1:0] pc;
    input [n-1:0] instr_data;
    output reg[n-1:0] ld_addr;
    input [n-1:0] ld_data;
    input reset, clk;

 	// you'll need more states than this
    parameter [2:0] state_if  = 0, state_id  = 1;
    reg[2:0] state;

	// the register file
    wire[1:0] reg_rd_num [0:1];
    wire[n-1:0] reg_rd_data [0:1];
    reg[1:0] reg_wr_num;
    reg[n-1:0] reg_wr_data;
    reg reg_wr_en;
    regfile #(.n(n)) regfile0(
        .wr_data(reg_wr_data), .wr_num(reg_wr_num), .wr_en(reg_wr_en),
        .rd0_data(reg_rd_data[0]), .rd1_data(reg_rd_data[1]),
        .rd0_num(reg_rd_num[0]), .rd1_num(reg_rd_num[1]),
        .clk(clk));

    // processor regs
    reg[n-1:0] ir; // instruction register

	// useful for indexing IR
    parameter ir_opc_hi = 7;
    parameter ir_opc_lo = 6;
    parameter ir_imm = 5;
    parameter ir_reg1_hi = 4;
    parameter ir_reg1_lo = 3;
    parameter ir_reg0_hi = 2;
    parameter ir_reg0_lo = 1;
    parameter ir_dst = 0;

    always@(posedge clk or posedge reset) begin // stages
        if(reset) begin
            pc <= 0;
            state <= state_if;
        end
        else begin
            case(state)
                state_if: begin
                    ir <= instr_data;
                    pc <= pc + 1;
                    state <= state_id;
                end

                state_id: begin
					// ...
                    state <= state_if; // you'll need to change this
                end

				// add a case for each state that you define

                default: state <= state_if;
            endcase
        end
    end

endmodule
