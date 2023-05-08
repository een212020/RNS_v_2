`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module tb_32_31_21_5();
    // Size of dynamic range to be represented by the moduli set
    localparam DYN_SIZE = 16;
    // size of the moduli
    localparam MOD_SIZE_1 = 5;
    localparam MOD_SIZE_2 = 5;
    localparam MOD_SIZE_3 = 5;
    localparam MOD_SIZE_4 = 3;
    
    // largest modulus size
    localparam MAX_MOD = MOD_SIZE_1;
    
    // LUT sizes obtained from MATLAB script
    localparam LUT_SIZE_MOD_2 = 10;
    localparam LUT_SIZE_MOD_3 = 290;
    localparam LUT_SIZE_MOD_4 = 33;
    
    reg clk, reset;
    reg [DYN_SIZE - 1:0] N;
    reg [0:LUT_SIZE_MOD_2 - 1] LUT_mod_31 [0:0];
    reg [0:LUT_SIZE_MOD_3 - 1] LUT_mod_21 [0:0];
    reg [0:LUT_SIZE_MOD_4 - 1] LUT_mod_5 [0:0];
    wire [MAX_MOD - 1:0] out_mod_1, out_mod_2, out_mod_3, out_mod_4;
    
    integer i, f;
    
    initial begin
        $readmemb("LUT_mod_5.txt", LUT_mod_5);
        $readmemb("LUT_mod_21.txt", LUT_mod_21);
        $readmemb("LUT_mod_31.txt", LUT_mod_31);
        f = $fopen("output_32_31_21_5.txt","w");
        clk = 0;
        reset = 1; #0.5
        reset = 0;
        
        for (i=1; i<100; i=i+1)begin
            N = i;
            $fwrite(f,"%d %d %d %d\n",out_mod_1, out_mod_2, out_mod_3, out_mod_4);
            #2;
        end
        $finish;
        $fclose(f);
    end
    
    always #1 clk = ~clk;
    
    BIN2RNS_32_31_21_5 DUT(
    clk, reset,
    N,
    LUT_mod_31[0], LUT_mod_21[0], LUT_mod_5[0], 
    out_mod_1, out_mod_2, out_mod_3, out_mod_4
    );
endmodule
