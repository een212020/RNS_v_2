`timescale 1ns / 1ps

module tb_RNS2BIN_1();
    //number of moduli
    parameter MOD_NUM = 4;
    //max size of moduli
    parameter MOD_SIZE = 3;
    //size of dynamic range of the representation
    parameter RANGE = MOD_NUM * MOD_SIZE;
    
    reg clk, reset;
    reg [MOD_SIZE : 0] mod_1, mod_2, mod_3, mod_4;
    reg [MOD_SIZE - 1:0] c0, c1, c2, c3;  
    wire [RANGE - 1:0] n;
    
    initial begin
        clk = 0;
        mod_1 = 8;
        mod_2 = 7;
        mod_3 = 5;
        mod_4 = 3;
        reset = 0; #1
        reset = 1; #1
        reset = 0;
        c0 = 3;
        c1 = 6;
        c2 = 4;
        c3 = 2; #2
        c0 = 5;
        c1 = 1;
        c2 = 1;
        c3 = 1;
    end 
    
    always #1 clk = ~clk;
           
    RNS2BIN_1 DUT(
    clk, reset,
    mod_1, mod_2, mod_3, mod_4,
    c0, c1, c2, c3,
    n
    );
endmodule
