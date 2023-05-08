`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 15.04.2023 09:31:10
// Module Name: mod_gen_v_1
//////////////////////////////////////////////////////////////////////////////////


module mod_gen_v_1(
    N
    );
    input [15:0] N;
    //Number wrt whom the modulo will be generated
    localparam MOD = 21;
    //Periodicity = minimum distance between two distinct 1's in the sequence 
    //of residues of powers of 2 taken mod MOD
    localparam PERIOD = 6;
    //NUM_OF_STAGES = (2*PERIOD/3)-1 for multiples of 3 and (PERIOD-(PERIOD\3)-1) for others
    //where \ operator denotes integer division
    localparam NUM_OF_STAGES = 3;
    //Number of blocks required for first stage = PERIOD\3
    localparam STAGE_1 = 2;
    
    wire [PERIOD - 1:0] c [NUM_OF_STAGES-1:0];
    
    
    //generate full adder blocks for reduction
    genvar i;
    generate
        
    endgenerate
    
    
endmodule
