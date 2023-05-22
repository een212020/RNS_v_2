//Date: 21th December, 2022
//Testbench for BIN2RNS_LUT_1 - first run
///////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module tb_LUT_1();
    reg clk, reset;
    reg [31:0] n; 
    wire [2:0] out_mod_1, out_mod_2, out_mod_3, out_mod_4;
    
//    reg [9:0] i;
    integer i;    
    
    initial begin
        clk = 0;
        reset = 1; #0.5
        reset = 0;
        //generate all negative numbers allowed in dynamic range
        for (i=-420; i<0; i=i+1)begin
            n = i; #2;
        end 
        //generate all positive numbers allowed in dynamic range
        for (i=0; i<420; i=i+1)begin
            n = i; #2;
        end 
    end
    
    always #1 clk = ~clk;
    //DUT module instantiation
    BIN2RNS_LUT_1 DUT(clk, reset, n,
    out_mod_1, out_mod_2, out_mod_3, out_mod_4
    );
     
endmodule
