`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2021 01:10:02 PM
// Design Name: 
// Module Name: buttonToggle
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


module buttonToggle(
    input in,
    input clk,
    output out
    );
    
    reg bit = 0;    //inital value 0 to ensure no false starts
    reg out_reg, out_next;
    
    always @(posedge clk)
    begin
        out_reg <= out_next;
        bit <= out_next;
    end
    
    //next state logic
    always @(in)
    begin
        out_next = bit ^ in;
    end
    
    //output logic
    assign out = out_reg;
endmodule
