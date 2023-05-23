`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 4.02.2023 22:19:37
// Design Name: RNS to Binary converter 
// Module Name: RNS2BIN
// Project Name: RNS
//////////////////////////////////////////////////////////////////////////////////

module RNS2BIN_2(
    clk, reset,
    mod_1, mod_2, mod_3, mod_4,
    inv,
    c0, c1, c2, c3,
    n
    );
    //number of moduli
    parameter MOD_NUM = 4;
    //max size of moduli
    parameter MOD_SIZE = 5;
    //size of dynamic range of the representation
    parameter RANGE = MOD_NUM * MOD_SIZE;
    
    parameter LUT_SIZE = 128;
    parameter LUT_BIT_LENGTH = 8;
    
    input clk, reset;
    //moduli values
    input [MOD_SIZE : 0] mod_1, mod_2, mod_3, mod_4;
    // for storing modulo inverses calculated using ext_euc MATLAB script
    input [LUT_SIZE-1: 0] inv;
    //residue coefficients
    input [MOD_SIZE - 1: 0] c0, c1, c2, c3;
    //output binary number
    output reg [RANGE - 1: 0] n;
    
    //dynamic range
    reg [RANGE - 1: 0] M;
    // half of dynamic range
    reg [RANGE - 2: 0] M_by_2;
    //array of moduli
    reg [MOD_SIZE : 0] mod_val [MOD_NUM - 1: 0];
    //array of modular inverse of Q[i] under mod_val[i]
    reg [RANGE - 1: 0] A [MOD_NUM - 1: 0];
    // Q[i] = M/mod_val[i] 
    reg [RANGE - 1: 0] Q [MOD_NUM - 1: 0];
    // array of RNS digits
    reg [MOD_SIZE - 1: 0] C [MOD_NUM - 1: 0];
    
    integer i, j;
    
    always @(posedge clk) begin
        if (reset) begin
            for (i=0; i<MOD_NUM; i=i+1) begin
                Q[i] = 1;
            end
        end
        else begin
            for (i=0; i<MOD_NUM; i=i+1) begin
                Q[i] = 1;
            end
            
            mod_val[0] <= mod_1;
            mod_val[1] <= mod_2;
            mod_val[2] <= mod_3;
            mod_val[3] <= mod_4;
            C[0] <= c0;
            C[1] <= c1;
            C[2] <= c2;
            C[3] <= c3;
            //M = dynamic range
            M <= mod_1*mod_2*mod_3*mod_4; 
        end
    end
    
    always @(C[0], C[1], C[2], C[3]) begin
        // initialise to sum to zero
        n = 0;
        for (i=0; i<MOD_NUM; i=i+1) begin
        
            for (j=0; j<MOD_NUM; j=j+1) begin
                //find Q[i] = M/m[i]
                //Q[i] = (j==i)? Q[i]*1: Q[i]*mod_val[j];
                if(j!=i)
                    Q[i] = Q[i]*mod_val[j];
                $display("%d = %d/%d", Q[i], M, mod_val[i]);
            end
            
            //find modulo inverse of Q[i] under corresponding moduli base value
            A[i] = inv[i*LUT_BIT_LENGTH +: LUT_BIT_LENGTH]; 
            $display("Modulo inverse of %d under %d is %d", Q[i], mod_val[i], A[i]);
            //find the sum
            n = n + C[i]*A[i]*Q[i];
            $display("Updated sum = %d", n);
        end
        
        $display("final sum before reduction = %d", n);
        //if n is greater than dynamic range then find mod
        if (n > M) begin
            n = n%M;
        end
        M_by_2 = M>>1;
        $display(" M by 2 = %d", M_by_2);
        if (n >= M_by_2) begin
            n = -1*M_by_2 + (n - M_by_2); 
        end
    end
    
endmodule
