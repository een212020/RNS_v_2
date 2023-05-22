`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 12.1.2022 15:15:58
// Design Name: Binary to RNS converter
// Module Name: BIN2RNS_LUT_1
// Project Name: RNS
//////////////////////////////////////////////////////////////////////////////////

module bin2rns_mod(
    clk, reset, n, res_coeff_wire,
    mod_num, out_mod
    );
    //Bitsize of number
    parameter WIDTH = 32;
    //Largest representable number+1
    parameter MAX = 2**WIDTH;
    //Bitsize of residue
    parameter MOD_SIZE = 3;
    //Bitsize of temporary residue sum register
    parameter TEMP_RES_SIZE = 10;
    
    //inputs clock and number whose residue is to  be found
    input clk, reset; 
    input [MOD_SIZE:0] mod_num;
    input [WIDTH - 1:0] n;
    //flattened array to load LUT values from LUT modules
    input [MOD_SIZE * WIDTH - 1:0] res_coeff_wire;
    
    //output
    output reg [MOD_SIZE - 1:0] out_mod;
    
    reg [WIDTH - 1:0] number, num, j;
    //temporary register to hold reduced residue values
    reg [TEMP_RES_SIZE - 1:0] res;
    
    //temporary register
    reg [MOD_SIZE-1:0] res_coeff;

     //find reduced residue
     always @(posedge clk or posedge reset) begin
        if(reset!=0)begin
            number <= 0;
            res <= 0;
        end
        else begin
            number <= n;
        end
    end    
    
    //check if number is positive or negative
    //if negative take 2's complement of number to find the equivalent positive number 
    //and use num[9] as flag
    always @(number)begin
        num = number;
        if(num[WIDTH-1]==1) begin
            num = MAX - num;
            num[WIDTH-1] = 1;
        end
    end
    
    //find mod 
    always @(num)begin
        if(mod_num%2==0)begin
            case(mod_num)
                10'b0000000010: out_mod = num[0];
                10'b0000000100: out_mod = num[1:0];
                10'b0000001000: out_mod = num[2:0];
                10'b0000010000: out_mod = num[3:0];
                10'b0000100000: out_mod = num[4:0];
                10'b0001000000: out_mod = num[5:0];
                10'b0010000000: out_mod = num[6:0];
                10'b0100000000: out_mod = num[7:0];
                10'b1000000000: out_mod = num[8:0];
                default: out_mod = 0;
            endcase
        end
        else begin
            //calculate residue from LUT 
            res = 0;
            for(j = 0; j<WIDTH-1; j=j+1)begin
                res_coeff = res_coeff_wire[MOD_SIZE*j +: MOD_SIZE];
                res = res + res_coeff*num[j];
                $display("mod residues: %d", res_coeff);
                $display("reduced residue values: %d", res);
            end
                
            out_mod = res%mod_num;
            $display("%b",out_mod);
            $display("%b", mod_num);
        end
        //if number is negative and out_mod value found is non-zero, 
        //find the mod value for the absolute value of the number
        if (num[WIDTH-1]==1 && out_mod!=0) begin
            out_mod = mod_num - out_mod;
        end
    end
    
endmodule
