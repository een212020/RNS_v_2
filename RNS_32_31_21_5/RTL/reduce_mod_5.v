`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 20.04.2023 19:07:30 
// Module Name: reduce_mod_5
// Module Description: Reduces 16 bit number to a smaller-bit number for residue 
// calculation
//////////////////////////////////////////////////////////////////////////////////


module reduce_mod_5(
    N, f_sum
    );
    //size of N
    localparam N_SIZE = 16;
    //Number wrt whom the modulo will be generated
    localparam MOD = 5;
    //Periodicity = minimum distance between two distinct 1's in the sequence 
    //of residues of powers of 2 taken mod MOD
    localparam PERIOD = 4;
    //NUM_OF_G = Number of PERIOD-bit groups into which input N can be divided
    //         = ceil(N/PERIOD)
    localparam NUM_OF_G = 4;
    //size of NUM_OF_G
    localparam N_G_SIZE = 3;
    //size of total sum
    localparam SUM_SIZE = PERIOD + N_G_SIZE;
    
    // NUM_OF_G1 = ceil(SUM_SIZE/PERIOD)
    localparam NUM_OF_G1 = 2;
    // size of NUM_OF_G1 = size of (NUM_OF_G1 - 1)
    localparam N_G1_SIZE = 1;
    // size of final sum
    localparam F_SUM_SIZE = PERIOD+N_G1_SIZE;
    
    input [15:0] N;
    reg [SUM_SIZE - 1:0] sum;
    reg [SUM_SIZE - 1:0] temp_sum;
    
    wire [PERIOD - 1:0] G [NUM_OF_G - 1:0];
    reg [NUM_OF_G - 1:0] j;
    
    //Divide N into sets of PERIOD length
    genvar i;
    generate
        for(i=0; i<NUM_OF_G-1; i=i+1) begin
            assign G[i] = N[PERIOD*i +: PERIOD];
        end
        assign G[NUM_OF_G -1]= {14'b0,N[N_SIZE-1:(NUM_OF_G-1)*PERIOD]};
    endgenerate
    
    //generate sum
    always @(N) begin
        sum = 0;   
        for(j=0; j<NUM_OF_G; j=j+1) begin
            sum = sum+G[j];
        end
        temp_sum = sum;
    end
    
    // Repeat process only if SUM_SIZE > PERIOD otherwise comment out

    output reg [F_SUM_SIZE - 1:0] f_sum;
    
    wire [PERIOD - 1:0] G1 [NUM_OF_G1 - 1:0];
    //reg [NUM_OF_G1 - 1:0] k;
    reg [NUM_OF_G1 - 1:0] l;
    
    genvar k;
    generate
        if(SUM_SIZE > PERIOD+1) begin
            for(k=0; k<NUM_OF_G1-1; k=k+1) begin
                assign G1[k] = temp_sum[PERIOD*k +: PERIOD];
            end
            assign G1[NUM_OF_G1 -1]= {14'b0,temp_sum[SUM_SIZE-1:(NUM_OF_G1-1)*PERIOD]};
        end
    endgenerate
    
    always@(temp_sum)begin
        f_sum = 0;   
    
        for(l=0; l<NUM_OF_G1; l=l+1) begin
            f_sum = f_sum+G1[l];
        end
    end
    
endmodule
