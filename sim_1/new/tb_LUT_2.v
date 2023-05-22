//Date: 14th January, 2022
//Testbench for BIN2RNS_LUT_1 - first run
///////////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module tb_LUT_2();
    reg clk, reset;
    reg [31:0] n;
    reg [3:0] mod_1, mod_2, mod_3, mod_4;
    wire [2:0] out_mod_1, out_mod_2, out_mod_3, out_mod_4;
    
//    reg [9:0] i;
    integer i, f;    
    
    initial begin
        f = $fopen("output1.txt","w");
        clk = 0;
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
            $fwrite(f,"%d %d %d %d\n",out_mod_1, out_mod_2, out_mod_3, out_mod_4);
        end 
        $fclose(f);
    end
    
    always #1 clk = ~clk;
    
    //DUT module instantiation
    BIN2RNS DUT(clk, reset, n,
    mod_1, mod_2, mod_3, mod_4,
    out_mod_1, out_mod_2, out_mod_3, out_mod_4
    );
     
endmodule
