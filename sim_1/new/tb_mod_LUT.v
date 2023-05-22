//Date: 14th December, 2022
//Testbench for BIN2RNS_mod_LUT - first run
///////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module tb_mod_LUT();
    reg clk;
    reg [9:0] n; 
    wire [2:0] mod8;
    wire [2:0] mod7, mod5;
    wire [1:0] mod3;
    
//    reg [9:0] i;
    integer i;    
    
    initial begin
        clk = 0;
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
    BIN2RNS_mod_LUT DUT(clk, n,  mod8, mod7, mod5, mod3);
     
endmodule
