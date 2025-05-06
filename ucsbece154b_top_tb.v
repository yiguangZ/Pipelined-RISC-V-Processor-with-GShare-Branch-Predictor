// ucsbece154b_top_tb.v
// All Rights Reserved
// Copyright (c) 2024 UCSB ECE
// Distribution Prohibited


`define SIM

`define ASSERT(CONDITION, MESSAGE) if ((CONDITION)==1'b1); else begin $error($sformatf MESSAGE); end

module ucsbece154b_top_tb ();

// test bench contents
reg clk = 1;
always #1 clk <= ~clk;
reg reset;

ucsbece154b_top top (
    .clk(clk), .reset(reset)
);

wire [31:0] reg_zero = top.riscv.dp.rf.zero;
wire [31:0] reg_ra = top.riscv.dp.rf.ra;
wire [31:0] reg_sp = top.riscv.dp.rf.sp;
wire [31:0] reg_gp = top.riscv.dp.rf.gp;
wire [31:0] reg_tp = top.riscv.dp.rf.tp;
wire [31:0] reg_t0 = top.riscv.dp.rf.t0;
wire [31:0] reg_t1 = top.riscv.dp.rf.t1;
wire [31:0] reg_t2 = top.riscv.dp.rf.t2;
wire [31:0] reg_s0 = top.riscv.dp.rf.s0;
wire [31:0] reg_s1 = top.riscv.dp.rf.s1;
wire [31:0] reg_a0 = top.riscv.dp.rf.a0;
wire [31:0] reg_a1 = top.riscv.dp.rf.a1;
wire [31:0] reg_a2 = top.riscv.dp.rf.a2;
wire [31:0] reg_a3 = top.riscv.dp.rf.a3;
wire [31:0] reg_a4 = top.riscv.dp.rf.a4;
wire [31:0] reg_a5 = top.riscv.dp.rf.a5;
wire [31:0] reg_a6 = top.riscv.dp.rf.a6;
wire [31:0] reg_a7 = top.riscv.dp.rf.a7;
wire [31:0] reg_s2 = top.riscv.dp.rf.s2;
wire [31:0] reg_s3 = top.riscv.dp.rf.s3;
wire [31:0] reg_s4 = top.riscv.dp.rf.s4;
wire [31:0] reg_s5 = top.riscv.dp.rf.s5;
wire [31:0] reg_s6 = top.riscv.dp.rf.s6;
wire [31:0] reg_s7 = top.riscv.dp.rf.s7;
wire [31:0] reg_s8 = top.riscv.dp.rf.s8;
wire [31:0] reg_s9 = top.riscv.dp.rf.s9;
wire [31:0] reg_s10 = top.riscv.dp.rf.s10;
wire [31:0] reg_s11 = top.riscv.dp.rf.s11;
wire [31:0] reg_t3 = top.riscv.dp.rf.t3;
wire [31:0] reg_t4 = top.riscv.dp.rf.t4;
wire [31:0] reg_t5 = top.riscv.dp.rf.t5;
wire [31:0] reg_t6 = top.riscv.dp.rf.t6;
wire  taken =  top.riscv.c.BranchTakenE_i;
wire  tog  =  top.riscv.c.PCSrcE_o;
wire  jumped  = top.riscv.c.JumpE;
wire  branched = top.riscv.c.BranchE;
wire [31:0] PCF    = top.riscv.dp.PCF_o;
// wire [31:0] MEM_10000000 = top.dmem.DATA[6'd0];

//

integer i;
  integer branch_total, branch_miss;
  integer jump_total,   jump_miss;
integer cycle_count;
reg [31:0] prevPC;
initial begin
$display( "Begin simulation." );
//\\ =========================== \\//
branch_total = 0;
branch_miss  = 0;
jump_total   = 0;
jump_miss    = 0;
cycle_count   = 0;
prevPC = 0;
reset = 1;
@(negedge clk);
@(negedge clk);
reset = 0;

// Test for program
for (i = 0; i < 500 && PCF != 32'h00010064; i = i + 1) begin
    @(posedge clk);
    cycle_count = cycle_count + 1;
    if (jumped==1)begin
        if (taken==1)begin
            jump_total=jump_total+1;
        end
        else begin
        jump_total=jump_total+1;
        jump_miss =jump_miss+1;
        end
    end
    if (branched==1)begin
        if (tog==taken)begin
            branch_total=branch_total+1;
        end
        else begin
        branch_total=branch_total+1;
        branch_miss =branch_miss+1;
        end
    end
    prevPC = PCF;
end
// WRITE YOUR TEST HERE

// `ASSERT(rg_zero==32'b0, ("reg_zero incorrect"));
// `ASSERT(MEM_10000070==32'hBEEF000, ("mem.DATA[29] //incorrect"));


//\\ =========================== \\//
$display("\n=== Simulation complete ===");
$display("Total cycles............: %0d", cycle_count);
$display("Branch total............: %0d", branch_total);
$display("Branch mispredictions...: %0d", branch_miss);
$display("Branch mispredict rate..: %0f%%", branch_total ? 100.0 * branch_miss / branch_total : 0.0);
$display("Jump total..............: %0d", jump_total);
$display("Jump mispredictions.....: %0d", jump_miss);
$display("Jump mispredict rate....: %0f%%",jump_total ? 100.0 * jump_miss / jump_total : 0.0);

$stop;
end

endmodule

`undef ASSERT