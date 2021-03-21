`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2021 09:59:10 PM
// Design Name: 
// Module Name: BCD_counter_doneParameter
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


module BCD_counter_doneParameter
    #(parameter count = 9)(
    input clk,
    input reset_n,
    input enable,
    output done,
    output [3:0] Q
    );
    
    reg [3:0] Q_reg, Q_next;
    
    always @(posedge clk, negedge reset_n)
    begin
        if (~reset_n)
            Q_reg <= 'b0;
        else if(enable)
            Q_reg <= Q_next;
        else
            Q_reg <= Q_reg;
    end
    
    // Next state logic
    // Hard coded final value
    assign done = Q_reg == count;   //added parameter to change desired max count per instance

    always @(*)
        Q_next = done? 'b0: Q_reg + 1;
    
    // Output logic
    assign Q = Q_reg;
endmodule
