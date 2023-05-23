`timescale 1ns / 1ps

module tb_BIN2RNS2BIN_1();
    //Bitsize of number
    parameter WIDTH = 32;
    //Largest representable number+1
    parameter MAX = 2**WIDTH;
    //Bitsize of residues
    parameter MOD_SIZE = 3;
    //Number of moduli
    parameter N_MOD = 4;    
    //size of dynamic range of the representation
    parameter RANGE = N_MOD * MOD_SIZE;
    //max size of element of modulo inverse LUT
    parameter MAX_MOD_INV_SIZE = 2;
    
    reg clk0, clk1, reset;
    reg [WIDTH - 1:0] n;
    reg [MOD_SIZE:0] mod_1, mod_2, mod_3, mod_4;
    wire [MOD_SIZE - 1:0] out_mod_1, out_mod_2, out_mod_3, out_mod_4;
    wire [RANGE - 1 : 0] out;
    
    reg [MOD_SIZE * WIDTH * N_MOD - 1:0] LUT [0:0];
    reg [0:N_MOD*MAX_MOD_INV_SIZE - 1] inv [0:0];
    
    integer i;    
    
    initial begin
        $readmemb("LUT1.txt", LUT);
        $readmemb("mod_inv_coeff_8_7_5_3.txt", inv);
        clk0 = 0;
        clk1 = 0;
        mod_1 = 8;
        mod_2 = 7;
        mod_3 = 5;
        mod_4 = 3;
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
        $finish;
    end
    
    always begin 
        #0.5 clk0 = ~clk0;
        #0.5 clk1 = ~clk1;
    end
    
    //DUT module instantiation
    BIN2RNS_LUT_3 DUT0(clk0, reset, n, mod_1, mod_2, mod_3, mod_4,
    LUT[0],
    out_mod_1, out_mod_2, out_mod_3, out_mod_4);
    
    RNS2BIN_2 DUT1( clk1, reset,
    mod_1, mod_2, mod_3, mod_4,
    inv[0],
    out_mod_1, out_mod_2, out_mod_3, out_mod_4,
    out
    );
     
endmodule
