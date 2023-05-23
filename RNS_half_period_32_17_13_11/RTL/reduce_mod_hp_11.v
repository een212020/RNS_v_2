`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 20.04.2023 19:07:30 
// Module Name: reduce_mod_hp_11
// Module Description: Reduces 16 bit number to a smaller-bit number for residue 
// calculation
//////////////////////////////////////////////////////////////////////////////////


module reduce_mod_hp_11(
    N, f_sum
    );
    //size of N
    localparam N_SIZE = 16;
    //Number wrt whom the modulo will be generated
    localparam MOD = 11;
    //Half periodicity = minimum distance between two subsequent pairs of 1 and MOD-1 in the sequence 
    //of residues of powers of 2 taken mod MOD
    localparam HALF_PERIOD = 5;
    //NUM_OF_G = Number of HALF_PERIOD-bit groups into which input N can be divided
    //         = ceil(N/HALF_PERIOD)
    localparam NUM_OF_G = 4;
    //size of NUM_OF_G
    localparam N_G_SIZE = 3;
    //size of total sum
    localparam SUM_SIZE = HALF_PERIOD + N_G_SIZE;
    // number of odd-numbered complemented bytes = 2*floor(NUM_OF_G/2)
    localparam floor_v_2 = 4;
    
    // NUM_OF_G1 = ceil(SUM_SIZE/HALF_PERIOD)
    localparam NUM_OF_G1 = 2;
    // size of NUM_OF_G1 = size of (NUM_OF_G1 - 1)
    localparam N_G1_SIZE = 1;
    // size of final sum
    localparam F_SUM_SIZE = HALF_PERIOD+N_G1_SIZE;
    // number of odd-numbered complemented bytes = 2*floor(NUM_OF_G1/2)
    localparam floor_v_2_1 = 2;
    
    input [15:0] N;
    reg [SUM_SIZE - 1:0] sum;
    reg [SUM_SIZE - 1:0] temp_sum;
    
    wire [HALF_PERIOD - 1:0] G [NUM_OF_G - 1:0];
    reg [NUM_OF_G - 1:0] j;
    
    //Divide N into sets of HALF_PERIOD length
    genvar i;
    generate
        for(i=0; i<NUM_OF_G-1; i=i+2) begin
            assign G[i] = N[HALF_PERIOD*i +: HALF_PERIOD];
        end
        for(i=1; i<NUM_OF_G-1; i=i+2) begin
            assign G[i] = ~N[HALF_PERIOD*i +: HALF_PERIOD];
        end
        if(NUM_OF_G[0] == 0)
            assign G[NUM_OF_G -1]= ~{14'b0,N[N_SIZE-1:(NUM_OF_G-1)*HALF_PERIOD]};
        else
            assign G[NUM_OF_G -1]= {14'b0,N[N_SIZE-1:(NUM_OF_G-1)*HALF_PERIOD]};
    endgenerate
    
    //generate sum
    always @(N) begin
        sum = 0;   
        for(j=0; j<NUM_OF_G; j=j+1) begin
            sum = sum+G[j];
        end
        temp_sum = sum+floor_v_2;
    end
    
    // Repeat process only if SUM_SIZE > HALF_PERIOD otherwise comment out
    
    output reg [F_SUM_SIZE - 1:0] f_sum;
    
    wire [HALF_PERIOD - 1:0] G1 [NUM_OF_G1 - 1:0];
    //reg [NUM_OF_G1 - 1:0] k;
    reg [NUM_OF_G1 - 1:0] l;
    
    genvar k;
    generate
        if(SUM_SIZE > HALF_PERIOD+1) begin
            for(k=0; k<NUM_OF_G1-1; k=k+2) begin
                assign G1[k] = temp_sum[HALF_PERIOD*k +: HALF_PERIOD];
            end
            for(k=1; k<NUM_OF_G1-1; k=k+2) begin
                assign G1[k] = ~temp_sum[HALF_PERIOD*k +: HALF_PERIOD];
            end
            if (NUM_OF_G1[0] == 0)
                assign G1[NUM_OF_G1 -1]= ~{14'b0,temp_sum[SUM_SIZE-1:(NUM_OF_G1-1)*HALF_PERIOD]};
            else
                assign G1[NUM_OF_G1 -1]= {14'b0,temp_sum[SUM_SIZE-1:(NUM_OF_G1-1)*HALF_PERIOD]};
        end
    endgenerate
    
    always@(temp_sum)begin
        f_sum = 0;   
    
        for(l=0; l<NUM_OF_G1; l=l+1) begin
            f_sum = f_sum+G1[l];
        end
        f_sum = f_sum + floor_v_2_1;
    end
    
endmodule
