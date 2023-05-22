`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 4.02.2023 22:19:37
// Design Name: RNS to Binary converter 
// Module Name: RNS2BIN
// Project Name: RNS
//////////////////////////////////////////////////////////////////////////////////

module RNS2BIN_1(
    clk, reset,
    mod_1, mod_2, mod_3, mod_4,
    c0, c1, c2, c3,
    n
    );
    //number of moduli
    parameter MOD_NUM = 4;
    //max size of moduli
    parameter MOD_SIZE = 3;
    //size of dynamic range of the representation
    parameter RANGE = MOD_NUM * MOD_SIZE;
    
    input clk, reset;
    //moduli values
    input [MOD_SIZE : 0] mod_1, mod_2, mod_3, mod_4;
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
            A[i] = mod_inv(Q[i], mod_val[i]); 
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
    
    //function to find modulo inverse of Q_1 under M_1 using Extended Euclidean Algorithm
    function [RANGE - 1: 0] mod_inv;
        input [RANGE - 1: 0] Q_1, M_1;
        integer quo; 
        reg [RANGE - 1: 0] temp;
        reg [RANGE - 1: 0] x, y, m0; 
        begin
            //initial values of x and y where x and y are the Bezout's coefficients
            y = 0;
            x = 1;
            //save M_1 value 
            m0 = M_1;
            
            if (M_1 == 1)
                mod_inv = 1;
            
            while (Q_1 > 1) begin
                //quo is integral quotient
                quo = Q_1 / M_1;
                temp = M_1;
                
                //M_1 is now remainder
                M_1 = Q_1 % M_1;
                Q_1 = temp;
                temp = y;
                
                //update y and x
                y = x - quo*y;
                x = temp;                
            end
            
            //make x positive
            if (x < 0) begin
                x = x + m0;
            end
            
            // return value of x
            mod_inv = x;
            
        end
    endfunction
endmodule
