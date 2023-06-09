`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Description: Testbench for RNS to BIN for moduli set (32, 31, 21, 5)
//////////////////////////////////////////////////////////////////////////////////


module tb_RNS2BIN_32_31_21_5();
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
    localparam LUT_SIZE_MOD_5 = 42;
    
    // input ports
    reg clk, reset;
    reg [MAX_MOD - 1: 0] x0, x1, x2, x3;
    
    reg [0:N_MOD*N_MOD*MAX_CH_COEFF_BITS - 1] ch_mat [0:0];
    
    reg [0: LUT_SIZE_MOD_105 - 1] LUT_mod_105 [0:0];
    reg [0: LUT_SIZE_MOD_5 - 1] LUT_mod_5 [0:0];
    
    // output ports
    wire [DYN_SIZE - 1:0] N;
    wire [DYN_SIZE - 1: 0] B_mod_0;
    wire [DYN_SIZE - 1: 0] B_mod_1;
    wire [DYN_SIZE - 1: 0] B_mod_2;
    wire [DYN_SIZE - 1: 0] B_mod_3;
    
    integer i, f;
    
    initial begin
        // read LUT files
        $readmemb("LUT_mod_5.txt", LUT_mod_5);
        $readmemb("LUT_mod_105.txt", LUT_mod_105);
        $readmemb("ch_mat_coeff_32_31_21__5.txt", ch_mat);
        clk = 0;
        reset = 1; #0.5
        reset = 0;
        
        // add cases to be tested 
        x0 = 31;
        x1 = 1;
        x2 = 15;
        x3 = 0;
        
    end
    
    // clock generation
    always #1 clk = ~clk;
    
    // DUT instantiation
    RNS2BIN_32_31_21_5 DUT(
    clk, reset,
    x0, x1, x2, x3,
    B_mod_0,B_mod_1,B_mod_2,B_mod_3,
    ch_mat[0],
    LUT_mod_105[0], LUT_mod_5[0],
    N
    );
endmodule
