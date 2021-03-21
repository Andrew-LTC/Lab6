`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2021 10:01:42 PM
// Design Name: 
// Module Name: stopwatch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stopwatch(
    input resetButton,
    input pushButton,
    input CLK100MHZ,
    output DP,
    output [7:0] AN,
    output [6:0] SEG
    );
    
    //button outputs
    wire reset, push;
    //buttons
    button Reset (
        .clk(CLK100MHZ),
        .in(resetButton),
        .out(reset)
    );
    button Push (
        .clk(CLK100MHZ),
        .in(pushButton),
        .out(push)
    );
    
    //toggle function for start/pause/continue
    wire pushOut;
    buttonToggle PushToggle (
        .in(push),
        .clk(CLK100MHZ),
        .out(pushOut)
    );
    //BCD counters enables
    wire msHunsEn,msTensEn,secOnesEn,secTensEn,minOnesEn,minTensEn;
    //BCD counters dones
    wire doneMsHuns,doneMsTens,doneSOnes,doneSTens,doneMinOnes;
    
    //AND gate enables for cascaded BCD counters
    assign msTensEn = msHunsEn & doneMsHuns;
    assign secOnesEn = msTensEn & doneMsTens;
    assign secTensEn = secOnesEn & doneSOnes;
    assign minOnesEn = secTensEn & doneSTens;
    assign minTensEn = minOnesEn & doneMinOnes;
    
    //outputs of BCD counters
    wire [3:0] msHunsOUT,msTensOUT,secOnesOUT,secTensOUT,minOnesOUT,minTensOUT;
    
    //need a base clock of .01 seconds for cascade BCD counters
    //.01s = 10ms
    //Final Value = 10ms/10ns = 1,000,000 - 1 = 999_999
    timer_parameter #(.FINAL_VALUE(999_999)) baseCounter (
        .clk(CLK100MHZ),
        .reset_n(~reset),
        .enable(pushOut),
        .done(msHunsEn)
    );
    
    //need 6 BCD counters for 6 digits
    BCD_counter_doneParameter #(.count(9)) msHuns (
        .clk(CLK100MHZ),
        .reset_n(~reset),
        .enable(msHunsEn),
        .done(doneMsHuns),
        .Q(msHunsOUT)
    );
    BCD_counter_doneParameter #(.count(9)) msTens (
        .clk(CLK100MHZ),
        .reset_n(~reset),
        .enable(msTensEn),
        .done(doneMsTens),
        .Q(msTensOUT)
    );
    BCD_counter_doneParameter #(.count(9)) secOnes (
        .clk(CLK100MHZ),
        .reset_n(~reset),
        .enable(secOnesEn),
        .done(doneSOnes),
        .Q(secOnesOUT)
    );
    BCD_counter_doneParameter #(.count(5)) secTens (
        .clk(CLK100MHZ),
        .reset_n(~reset),
        .enable(secTensEn),
        .done(doneSTens),
        .Q(secTensOUT)
    );
    BCD_counter_doneParameter #(.count(9)) minOnes (
        .clk(CLK100MHZ),
        .reset_n(~reset),
        .enable(minOnesEn),
        .done(doneMinOnes),
        .Q(minOnesOUT)
    );
    BCD_counter_doneParameter #(.count(5)) minTens (
        .clk(CLK100MHZ),
        .reset_n(~reset),
        .enable(minTensEn),
        .Q(minTensOUT)
    );
    
    //use display driver to show outputs
    sseg_driver Display (
        .I7(6'b0),
        .I6(6'b0),
        .I5({1'b1,minTensOUT,1'b0}),
        .I4({1'b1,minOnesOUT,1'b1}),
        .I3({1'b1,secTensOUT,1'b0}),
        .I2({1'b1,secOnesOUT,1'b1}),
        .I1({1'b1,msTensOUT,1'b0}),
        .I0({1'b1,msHunsOUT,1'b0}),
        .CLK100MHZ(CLK100MHZ),
        .SSEG(SEG),
        .AN(AN),
        .DP(DP)
    );
endmodule
