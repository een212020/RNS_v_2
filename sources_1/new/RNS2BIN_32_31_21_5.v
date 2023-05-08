`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 30.04.2023 12:31:06
// Module Name: RNS2BIN_32_31_21_5
//////////////////////////////////////////////////////////////////////////////////


module RNS2BIN_32_31_21_5(
    clk, reset,
    x0, x1, x2, x3,
    ch_mat,
    LUT_mod_105, LUT_mod_5,
    N
    );
    // Size of dynamic range to be represented by the moduli set
    localparam DYN_SIZE = 16;
    // Number of moduli in set to be used
    localparam N_MOD = 4;
    // Define as many mod_n parameters as in set
    // Put modulus of the form 2^(mod_1_k) in mod_1 
    localparam MOD_1 = 32;
    localparam MOD_1_K = 5;
    // Moduli that are not of the form 2^k
    localparam MOD_2 = 31;
    localparam MOD_3 = 21;
    localparam MOD_4 = 5;
    // size of the moduli
    localparam MOD_SIZE_1 = 5;
    localparam MOD_SIZE_2 = 5;
    localparam MOD_SIZE_3 = 5;
    localparam MOD_SIZE_4 = 3;
    // largest modulus size
    localparam MAX_MOD = MOD_SIZE_1;
    
    // largest characteristic matrix coefficient size as obtained
    // from the MATLAB code = mat_bits
    localparam MAX_CH_COEFF_BITS = 5;
    
    // LUTs not under original moduli required of
    localparam MOD_105 = 105;
    localparam MOD_SIZE_105 = 7;
    
    // LUT sizes obtained from MATLAB script
    localparam LUT_SIZE_MOD_105 = 2289;
    localparam LUT_SIZE_MOD_5 = 33;
    
    input clk, reset;
    input [MAX_MOD - 1: 0] x0, x1, x2, x3;
    input [0:N_MOD*N_MOD*MAX_CH_COEFF_BITS - 1] ch_mat;
    
    input [0: LUT_SIZE_MOD_105 - 1] LUT_mod_105;
    input [0: LUT_SIZE_MOD_5 - 1] LUT_mod_5;
    
    output reg [DYN_SIZE - 1:0] N;
    
    reg [MAX_MOD - 1: 0] A [N_MOD - 1:0][N_MOD - 1:0];
    reg [MAX_MOD - 1: 0] B [N_MOD - 1:0];
    reg [MAX_MOD - 1: 0] B_mod [N_MOD - 1:0];
    reg [MAX_MOD - 1: 0] x [N_MOD - 1:0];
    reg [N_MOD - 1:0] i, j;
    reg [DYN_SIZE - 1: 0] temp_sum;
    reg [DYN_SIZE - 1: 0] temp_N;
    reg [DYN_SIZE - 1: 0] m_prod;
    
    reduce_mod_5 A1(B[4], temp_4);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            N <= 0;
            for (i=0; i<N_MOD;i=i+1)
                x[i] <= 0;
            for (i=0; i<N_MOD;i=i+1) begin
                for (j=0;j<N_MOD;j=j+1)begin
                    A[i][j] = ch_mat[(i*N_MOD+j)*MAX_CH_COEFF_BITS +: MAX_CH_COEFF_BITS];
                end
            end
        end
        else begin
            x[0] <= x0;
            x[1] <= x1;
            x[2] <= x2;
            x[3] <= x3;
        end
    end
    
    always @(x[0], x[1], x[2], x[3]) begin
        for (i=0; i<N_MOD; i=i+1)begin
            temp_sum = 0;
            for (j=0; j<N_MOD; j=j+1) begin
                temp_sum = temp_sum + A[i][j]*x[j];
            end
            B[i] = temp_sum;
        end
      
        B_mod[0] = B[0];
        B_mod[1] = B[1];
        
        if(B_mod[2] < MOD_105)
            B_mod[2] = B[2];
        else
            B_mod[2] = LUT_mod_105[(B_mod[2]-MOD_105)*MOD_SIZE_105 +: MOD_SIZE_105];
        
        if(temp_4 < MOD_4)
            B_mod[4] = temp_4;
        else
            B_mod[4] = LUT_mod_5[(temp_4-MOD_4)*MOD_SIZE_4 +: MOD_SIZE_4];
            
        m_prod = x[0];
        temp_N = B_mod[0];
        for (i=1; i<N_MOD; i=i+1)begin
            temp_N = temp_N + B_mod[i]*m_prod;
            m_prod = m_prod*x[i];
        end
        
        N = temp_N;
    end
endmodule
