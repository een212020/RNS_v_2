//Date: 21th January, 2023
//Testbench for BIN2RNS_LUT_3 - third run
///////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module tb_LUT_4();
    //Bitsize of number
    parameter WIDTH = 32;
    //Largest representable number+1
    parameter MAX = 2**WIDTH;
    //Bitsize of residues
    parameter MOD_SIZE = 3;
    //Number of moduli
    parameter N_MOD = 4;
    
    reg clk, reset;
    reg [WIDTH - 1:0] n;
    reg [MOD_SIZE:0] mod_1, mod_2, mod_3, mod_4;
    wire [MOD_SIZE - 1:0] out_mod_1, out_mod_2, out_mod_3, out_mod_4;
    
    reg [MOD_SIZE * WIDTH * N_MOD - 1:0] LUT [0:0];
    
    integer i, f;    
    
    initial begin
        f = $fopen("output1.txt","w");
        $readmemb("LUT1.txt", LUT);
        clk = 0;
        mod_1 = 8;
        mod_2 = 7;
        mod_3 = 5;
        mod_4 = 3;
        reset = 1; #0.5
        reset = 0;
//        $fwrite(f,"   N 8 7 5 3\n");
//        //generate all negative numbers allowed in dynamic range
//        for (i=-420; i<0; i=i+1)begin
//            n = i; #2;
//            $fwrite(f,"%0d %d %d %d %d\n",i, out_mod_1, out_mod_2, out_mod_3, out_mod_4);
//        end 
        //generate all positive numbers allowed in dynamic range
        for (i=0; i<420; i=i+1)begin
            n = i; #2;
//            $fwrite(f,"%0d %d %d %d %d\n",n, out_mod_1, out_mod_2, out_mod_3, out_mod_4);
            
            $fwrite(f,"%d %d %d %d\n", out_mod_1, out_mod_2, out_mod_3, out_mod_4);
        end 
        $fclose(f);
    end
    
    always #1 clk = ~clk;
    
    //DUT module instantiation
    BIN2RNS_LUT_3 M1(clk, reset, n, mod_1, mod_2, mod_3, mod_4,
    LUT[0],
    out_mod_1, out_mod_2, out_mod_3, out_mod_4);
     
endmodule
