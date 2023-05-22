module tb_LUT_5();
    //Bitsize of number
    parameter WIDTH = 32;
    //Largest representable number+1
    parameter MAX = 2**WIDTH;
    //Bitsize of residues
    parameter MOD_SIZE = 3;
    //Number of moduli
    parameter N_MOD = 4;
    
    reg clk, reset;
    reg [WIDTH - 1:0] n;
    reg [MOD_SIZE:0] mod [N_MOD - 1:0];
    wire [MOD_SIZE - 1:0] out_mod [N_MOD - 1:0];
    
    reg [MOD_SIZE * WIDTH * N_MOD - 1:0] LUT [0:0];
    reg [MOD_SIZE*N_MOD - 1:0] dyn_range;
    
    integer i, k, f;    
    
    initial begin
        f = $fopen("output.txt","w");
        $readmemb("LUT1.txt", LUT);
        clk = 0;
        mod[0] = 8;
        mod[1] = 7;
        mod[2] = 5;
        mod[3] = 3;
        
        dyn_range = 1;
        for (i=0; i<N_MOD; i=i+1) begin
            dyn_range = dyn_range*mod[i];
        end
        
        reset = 1; #0.5
        reset = 0;
        //generate all negative numbers allowed in dynamic range
        for (i=-dyn_range; i<0; i=i+1)begin
            n = i; #2;
        end 
        //generate all positive numbers allowed in dynamic range
        for (i=0; i<dyn_range; i=i+1)begin
            n = i; #2;
            for(k=0; k<N_MOD; k=k+1) begin
                $fwrite(f,"%d ",out_mod[k]);
            end
            $fwrite(f,"\n");
        end 
        $fclose(f);
    end
    
    always #1 clk = ~clk;
    
    //DUT module instantiation
//    BIN2RNS_LUT_3 M1(clk, reset, n, mod_1, mod_2, mod_3, mod_4,
//    LUT[0],
//    out_mod_1, out_mod_2, out_mod_3, out_mod_4);
    genvar j;
    generate
        for(j = 0; j< N_MOD ; j=j+1)begin: generate_block_identifier
            bin2rns_mod M(.clk(clk), .reset(reset),.n(n), .res_coeff_wire(), .mod_num(mod[j]), .out_mod(out_mod[j]));
        end
    endgenerate
     
endmodule
