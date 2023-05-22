`timescale 1ns / 1ps

module LUT_test(
    clk, addr, data
    );
    input clk;
    input [3:0] addr;
    output reg [7:0] data;    
    reg [7:0] test_memory [0:15];
    
    initial begin
        $readmemh("LUT.txt", test_memory);
    end
    
    always @(posedge clk) begin
        data = test_memory[addr];
    end
endmodule