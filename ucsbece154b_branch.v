// ucsbece154_branch.v
// All Rights Reserved
// Copyright (c) 2024 UCSB ECE
// Distribution Prohibited


module ucsbece154b_branch #(
    parameter NUM_BTB_ENTRIES = 32,
    parameter NUM_GHR_BITS    = 5
)(
    input               clk, 
    input               reset_i,
    input        [31:0] pc_i,
    input  [31:0] BTBwriteaddress_i,
    input        [31:0] BTBwritedata_i,   
    output reg   [31:0] BTBtarget_o,           
    input               BTB_we, 
    output reg          BranchTaken_o,
    input         [6:0] op_i, 
    input         [6:0] op_fi, 
    input               PHTincrement_i, 
    input               GHRreset_i,
    input               PHTwe_i,
    input               branchflag,
    input               jumpflag,
    input    [NUM_GHR_BITS-1:0]  PHTwriteaddress_i,
    output   reg [NUM_GHR_BITS-1:0]  PHTreadaddress_o

);

`include "ucsbece154b_defines.vh"

// YOUR CODE HERE
reg branchhit;
reg jumphit;
reg [31:0] keys [0:NUM_BTB_ENTRIES-1];
reg [31:0] values [0:NUM_BTB_ENTRIES-1];
reg [0:NUM_BTB_ENTRIES-1] J;
reg [0:NUM_BTB_ENTRIES-1] B;
integer i;
integer j;
integer k;
always @(posedge clk or posedge reset_i) begin
    if (reset_i) begin
        for (i = 0; i < NUM_BTB_ENTRIES; i = i + 1) begin
            keys[i] <= 0;
            values[i] <= 0;
            J[i] <=0;
            B[i] <=0;
        end
    end else if (BTB_we) begin
        j=0;
        for (i = 0; i < NUM_BTB_ENTRIES; i = i + 1) begin
            if (keys[i]==BTBwriteaddress_i) begin
                j=1;
            end
        end

        if (j==0) begin
            for (i = 0; i < NUM_BTB_ENTRIES-1; i = i + 1) begin
                keys[i+1]<=keys[i];
                values[i+1]<=values[i];
                J[i+1]<=J[i];
                B[i+1]<=B[i];
            end
            keys[0]<=BTBwriteaddress_i;
            values[0]<=BTBwritedata_i;
            J[0]<=jumpflag;
            B[0]<=branchflag;
            
        end
    end
end
always @ * begin
    k=0;
    for (i = 0; i < NUM_BTB_ENTRIES; i = i + 1) begin
        if (keys[i]==pc_i && (B[i]|J[i])==1) begin
            BTBtarget_o <= values[i];
            branchhit = B[i];
            jumphit = J[i];
            k=1;
        end
        else if(k==0) begin
            BTBtarget_o <= 32'b0;
            branchhit = 1'b0;
            jumphit = 1'b0;
        end

    end
end
reg [NUM_GHR_BITS-1:0] GHR;
wire [NUM_GHR_BITS-1:0] PHTreadaddress;
reg [1:0] PHT [0:31];
wire predict_taken;
assign PHTreadaddress = pc_i[1+NUM_GHR_BITS:2] ^ GHR;
assign predict_taken = PHT[PHTreadaddress][1];
always @(posedge clk or posedge reset_i) begin
    if (reset_i || GHRreset_i) begin
        GHR <= {NUM_GHR_BITS{1'b0}};
        if (reset_i) begin
            for (i = 0; i < 32; i = i + 1) begin
                PHT[i] <= 2'b00;
            end
        end
    end else if (op_fi==7'b1100011) begin
        GHR <= {GHR[NUM_GHR_BITS-2:0], predict_taken};
        PHTreadaddress_o <= PHTreadaddress;
    end
    if (PHTwe_i) begin
        case(PHTincrement_i) 
        1'b1: begin
            case(PHT[PHTwriteaddress_i])
                2'b00:PHT[PHTwriteaddress_i]<=2'b01;
                2'b01:PHT[PHTwriteaddress_i]<=2'b10;
                2'b10:PHT[PHTwriteaddress_i]<=2'b11;
                2'b11:PHT[PHTwriteaddress_i]<=2'b11; 
            endcase
        end
        1'b0: begin
            case(PHT[PHTwriteaddress_i])
                2'b00:PHT[PHTwriteaddress_i]<=2'b00;
                2'b01:PHT[PHTwriteaddress_i]<=2'b00;
                2'b10:PHT[PHTwriteaddress_i]<=2'b01;
                2'b11:PHT[PHTwriteaddress_i]<=2'b10; 
            endcase
        end
        endcase
    end
end
always @ * begin
 BranchTaken_o <=  (predict_taken & branchhit) | jumphit;
end
endmodule
