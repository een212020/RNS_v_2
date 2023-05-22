`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 30.04.2023 12:31:06
// Module Name: RNS2BIN_32_31_21_5
//////////////////////////////////////////////////////////////////////////////////


module RNS2BIN_32_31_21_5(
    clk, reset,
    x0, x1, x2, x3,
    B_mod_0,B_mod_1,B_mod_2,B_mod_3,
    ch_mat,
    LUT_mod_105, LUT_mod_5,
    N
    );
    // Size of dynamic range to be represented by the moduli set
    localparam DYN_SIZE = 17;
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
    localparam LUT_SIZE_MOD_5 = 42;
    
    // input ports declaration
    input clk, reset;
    input [MAX_MOD - 1: 0] x0, x1, x2, x3;
    // stores characteristic matrix values
    input [0:N_MOD*N_MOD*MAX_CH_COEFF_BITS - 1] ch_mat; 
    // stores LUT values
    input [0: LUT_SIZE_MOD_105 - 1] LUT_mod_105;
    input [0: LUT_SIZE_MOD_5 - 1] LUT_mod_5;
    
    // output ports declaration
    output reg [DYN_SIZE :0] N;
    
    // A for loading values from ch_mat in matrix format
    reg [MAX_MOD - 1: 0] A [N_MOD - 1:0][N_MOD - 1:0];
    // B for storing first-order radix values
    reg [DYN_SIZE - 1: 0] B [N_MOD - 1:0];
    // B_mod for storing residue of B values
    reg [DYN_SIZE - 1: 0] B_mod [N_MOD - 1:0];
    // x for storing residue values
    reg [MAX_MOD - 1: 0] x [N_MOD - 1:0];
    // iterators
    reg [N_MOD - 1:0] i, j;
    // temporary sum for B calculation
    reg [DYN_SIZE - 1: 0] temp_sum;
    // temporary sum for final value calculation
    reg [DYN_SIZE : 0] temp_N;
    // m_prod for storing product of all moduli values
    reg [DYN_SIZE : 0] m_prod;
    // for storing moduli values
    reg [MAX_MOD : 0] moduli [N_MOD - 1:0];
    
    // output to check
    output reg [DYN_SIZE - 1: 0] B_mod_0;
    output reg [DYN_SIZE - 1: 0] B_mod_1;
    output reg [DYN_SIZE - 1: 0] B_mod_2;
    output reg [DYN_SIZE - 1: 0] B_mod_3;
    
    // temp_4 for storing reduced value mod MOD_4
    wire [4:0] temp_4;
    
    // module instantiation
    reduce_mod_5 A1(B[3], temp_4);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // load characteristic matrix values at reset
            for (i=0; i<N_MOD;i=i+1)
                x[i] <= 0;
            for (i=0; i<N_MOD;i=i+1) begin
                for (j=0;j<N_MOD;j=j+1)begin
                    A[i][j] <= ch_mat[(i*N_MOD+j)*MAX_CH_COEFF_BITS +: MAX_CH_COEFF_BITS];
                end
            end
        end
        else begin
            moduli[0] <= MOD_1;
            moduli[1] <= MOD_2;
            moduli[2] <= MOD_3;
            moduli[3] <= MOD_4;
            $display(" Moduli %d %d %d %d", moduli[0], moduli[1], moduli[2], moduli[3]);
            x[0] <= x0;
            x[1] <= x1;
            x[2] <= x2;
            x[3] <= x3;
        end
    end
    
    always @(*) begin
        // find values of first order radix B
        for (i=0; i<N_MOD; i=i+1)begin
            temp_sum = 0;
            for (j=0; j<N_MOD; j=j+1) begin
                temp_sum = temp_sum + A[i][j]*x[j];
            end
            B[i] = temp_sum;
            $display("B %d = %d", i, B[i]);
        end
        
        // assign to array for convenience
        B_mod[0] = B[0];
        B_mod_0 = B_mod[0];
        B_mod[1] = B[1];
        B_mod_1 = B_mod[1];
        // find residue value
        if(B[2] < MOD_105)
            B_mod[2] = B[2];
        else
            B_mod[2] = LUT_mod_105[(B[2]-MOD_105)*MOD_SIZE_105 +: MOD_SIZE_105];
        B_mod_2 = B_mod[2];
        // find residue value
        if(temp_4 < MOD_4)
            B_mod[3] = temp_4;
        else
            B_mod[3] = LUT_mod_5[(temp_4-MOD_4)*MOD_SIZE_4 +: MOD_SIZE_4];
        B_mod_3 = B_mod[3];
        
        $display("B0 %d B1 %d B2 %d B3 %d", B_mod[0], B_mod[1], B_mod[2], B_mod[3]);
        
        m_prod = moduli[0];
        temp_N = B_mod[0];
        // find Y
        for (i=1; i<N_MOD; i=i+1)begin
            temp_N = temp_N + B_mod[i]*m_prod;
            m_prod = m_prod*moduli[i];
        end
        $display("temp_N %d", temp_N);
        
        // calculate X = Y mod (MOD_1*MOD_2*MOD_3*MOD_4)
        if(temp_N >= m_prod<<1)begin
            N = temp_N - (m_prod<<1);
            end
        else if (temp_N >= m_prod)
            N = temp_N - m_prod;
        else
            N = temp_N; 
            
    end
endmodule
