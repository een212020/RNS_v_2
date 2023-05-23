`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 20.04.2023 19:10:50
// Module Name: BIN2RNS_32_17_13_11
// Module Description: Convert from binary to RNS for moduli set (32, 31, 15, 7)
//////////////////////////////////////////////////////////////////////////////////


module BIN2RNS_32_17_13_11(
    clk, reset,
    N,
    LUT_mod_2, LUT_mod_3, LUT_mod_4, 
    out_mod_1, out_mod_2, out_mod_3, out_mod_4
    );
    // Size of dynamic range to be represented by the moduli set
    localparam DYN_SIZE = 16;
    // Define as many mod_n parameters as in set
    // Put modulus of the form 2^(mod_1_k) in mod_1 
    localparam MOD_1 = 32;
    localparam MOD_1_K = 5;
    // Moduli that are not of the form 2^k
    localparam MOD_2 = 17;
    localparam MOD_3 = 13;
    localparam MOD_4 = 11;
    // size of the moduli
    localparam MOD_SIZE_1 = 5;
    localparam MOD_SIZE_2 = 5;
    localparam MOD_SIZE_3 = 4;
    localparam MOD_SIZE_4 = 4;
    
    // largest modulus size
    localparam MAX_MOD = MOD_SIZE_1;
    
    // LUT sizes obtained from MATLAB script
    localparam LUT_SIZE_MOD_2 = 80;
    localparam LUT_SIZE_MOD_3 = 464;
    localparam LUT_SIZE_MOD_4 = 216;
    
    input clk, reset;
    input [DYN_SIZE - 1:0] N;
    input [0: LUT_SIZE_MOD_2 - 1] LUT_mod_2;
    input [0: LUT_SIZE_MOD_3 - 1] LUT_mod_3;
    input [0: LUT_SIZE_MOD_4 - 1] LUT_mod_4;
    output reg [MAX_MOD - 1:0] out_mod_1, out_mod_2, out_mod_3, out_mod_4;
    
    reg [DYN_SIZE - 1:0] num;
    wire [4:0] temp_2;
    wire [6:0] temp_3;
    wire [4:0] temp_4;
    
    // Instantiate modules for reduction of the input N to a smaller-bit number 
    // with equivalent residue under the specified moduli value
    reduce_mod_hp_17 A1(N, temp_2);
    reduce_mod_hp_13 A2(N, temp_3);
    reduce_mod_hp_11 A3(N, temp_4);
    
    always @(posedge clk or posedge reset) begin
        if(!reset)begin
            num <= N;
        end
    end    
    
    // find residue of N under MOD_1
    always @(num) begin
        out_mod_1 = N[MOD_1_K - 1:0];
    end
    
    // find residue of N under MOD_2
    always @(num) begin
        if(temp_2 < MOD_2)
            out_mod_2 = temp_2;
        else
            out_mod_2 = LUT_mod_2[(temp_2-MOD_2)*MOD_SIZE_2 +: MOD_SIZE_2];
    end
    
    // find residue of N under MOD_3
    always @(num) begin
        if(temp_3 < MOD_3)
            out_mod_3 = temp_3;
        else
            out_mod_3 = LUT_mod_3[(temp_3-MOD_3)*MOD_SIZE_3 +: MOD_SIZE_3];
    end
    
    // find residue of N under MOD_4
    always @(num) begin
        if(temp_4 < MOD_4)
            out_mod_4 = temp_4;
        else
            out_mod_4 = LUT_mod_4[(temp_4-MOD_4)*MOD_SIZE_4 +: MOD_SIZE_4];
    end
endmodule