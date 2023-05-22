`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 22.12.2022 19:51:08
// Design Name: Binary to RNS converter
// Module Name: BIN2RNS_LUT_1
// Project Name: RNS
//////////////////////////////////////////////////////////////////////////////////

module BIN2RNS_LUT_1(
    clk, reset, n,
    out_mod_1, out_mod_2, out_mod_3, out_mod_4
    );
    //update MOD paramters depending on base used
    parameter MOD_1 = 8, MOD_2 = 7, MOD_3 = 5, MOD_4 = 3;
    //Bitsize of number
    parameter WIDTH = 32;
    //Largest representable number+1
    parameter MAX = 2**WIDTH;
    //Bitsize of residues
    parameter MOD_SIZE = 3;
    //Bitsize of temporary residue sum registers
    parameter TEMP_RES_SIZE = 10;
    
    //inputs clock and number whose residue is to  be found
    input clk, reset; 
    input [WIDTH - 1:0] n;
    //outputs #1, #2, #3, #4
    output reg [MOD_SIZE - 1:0] out_mod_1, out_mod_2, out_mod_3, out_mod_4;
    
    reg [WIDTH - 1:0] number, num, j;
    //temporary registers to hold reduced residue values
    reg [TEMP_RES_SIZE - 1:0] res_1, res_2, res_3, res_4;
    //flattened array to load LUT values from LUT modules
    wire [MOD_SIZE * WIDTH - 1:0] res_coeff_wire_1;
    wire [MOD_SIZE * WIDTH - 1:0] res_coeff_wire_2;
    wire [MOD_SIZE * WIDTH - 1:0] res_coeff_wire_3;
    wire [MOD_SIZE * WIDTH - 1:0] res_coeff_wire_4;
    
    //temporary registers
    reg [MOD_SIZE-1:0] res_coeff_1, res_coeff_2, res_coeff_3, res_coeff_4;
    
    //generate LUT module instantiations
    genvar i;
    generate
        for(i=0;i<WIDTH; i=i+1) begin: generate_block_identifier
            mod7_LUT LUT7(.n(i),.out(res_coeff_wire_2[MOD_SIZE*(i+1)-1: MOD_SIZE*i]));
            mod5_LUT LUT5(.n(i),.out(res_coeff_wire_3[MOD_SIZE*(i+1)-1: MOD_SIZE*i]));
            mod3_LUT LUT3(.n(i),.out(res_coeff_wire_4[MOD_SIZE*(i+1)-1: MOD_SIZE*i]));
        end    
    endgenerate

     //find reduced residues 
     always @(posedge clk or posedge reset) begin
        if(reset!=0)begin
            number <= 0;
            res_1 <= 0;
            res_2 <= 0;
            res_3 <= 0;
            res_4 <= 0;
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
    
    //find mod of first value
    always @(num)begin
        if(MOD_1%2==0)begin
            case(MOD_1)
                10'b0000000010: out_mod_1 = num[0];
                10'b0000000100: out_mod_1 = num[1:0];
                10'b0000001000: out_mod_1 = num[2:0];
                10'b0000010000: out_mod_1 = num[3:0];
                10'b0000100000: out_mod_1 = num[4:0];
                10'b0001000000: out_mod_1 = num[5:0];
                10'b0010000000: out_mod_1 = num[6:0];
                10'b0100000000: out_mod_1 = num[7:0];
                10'b1000000000: out_mod_1 = num[8:0];
                default: out_mod_1 = 0;
            endcase
        end
        else begin
            //calculate residue from LUT 
            res_1 = 0;
            for(j = 0; j<WIDTH-1; j=j+1)begin
//                    num <= num + res_coeff_wire_1[MOD_SIZE*j +: MOD_SIZE]*num[j];
                res_coeff_1 = res_coeff_wire_1[MOD_SIZE*j +: MOD_SIZE];
                res_1 = res_1 + res_coeff_1*num[j];
                $display("mod 8 residues: %d", res_coeff_1);
                $display("reduced residue 8 values: %d", res_1);
            end
                
            out_mod_1 = res_1%MOD_1;
        end
        //if number is negative and out_mod_1 value found is non-zero, 
        //find the mod value for the absolute value of the number
        if (num[WIDTH-1]==1 && out_mod_1!=0) begin
            out_mod_1 = MOD_1 - out_mod_1;
        end
    end
    
    //find second mod value
    always @(num)begin
        if(MOD_2%2==0)begin
            case(MOD_2)
                10'b0000000010: out_mod_2 = num[0];
                10'b0000000100: out_mod_2 = num[1:0];
                10'b0000001000: out_mod_2 = num[2:0];
                10'b0000010000: out_mod_2 = num[3:0];
                10'b0000100000: out_mod_2 = num[4:0];
                10'b0001000000: out_mod_2 = num[5:0];
                10'b0010000000: out_mod_2 = num[6:0];
                10'b0100000000: out_mod_2 = num[7:0];
                10'b1000000000: out_mod_2 = num[8:0];
                default: out_mod_2 = 0;
            endcase
        end
        else begin
            res_2 = 0;
            for(j = 0; j<WIDTH-1; j=j+1)begin
//                    num <= num + res_coeff_wire_2[MOD_SIZE*j +: MOD_SIZE]*num[j];
                res_coeff_2 = res_coeff_wire_2[MOD_SIZE*j +: MOD_SIZE];
                res_2 = res_2 + res_coeff_2*num[j];
                $display("mod 7 residues: %d", res_coeff_2);
                $display("reduced residue 7 values: %d", res_2);
            end
            
            out_mod_2 = res_2%MOD_2;
        end
        
        if (num[WIDTH-1]==1 && out_mod_2!=0) begin
            out_mod_2 = MOD_2 - out_mod_2;
        end
    end
    
    //find third mod value
    always @(num)begin
        if(MOD_3%2==0)begin
            case(MOD_3)
                10'b0000000010: out_mod_3 = num[0];
                10'b0000000100: out_mod_3 = num[1:0];
                10'b0000001000: out_mod_3 = num[2:0];
                10'b0000010000: out_mod_3 = num[3:0];
                10'b0000100000: out_mod_3 = num[4:0];
                10'b0001000000: out_mod_3 = num[5:0];
                10'b0010000000: out_mod_3 = num[6:0];
                10'b0100000000: out_mod_3 = num[7:0];
                10'b1000000000: out_mod_3 = num[8:0];
                default: out_mod_3 = 0;
            endcase
        end
        else begin
            res_3 = 0;
            for(j = 0; j<WIDTH-1; j=j+1)begin
//                num <= num + res_coeff_wire_3[MOD_SIZE*j +: MOD_SIZE]*num[j];
                res_coeff_3 = res_coeff_wire_3[MOD_SIZE*j +: MOD_SIZE];
                res_3 = res_3 + res_coeff_3*num[j];
                $display("mod 5 residues: %d", res_coeff_3);
                $display("reduced residue 5 values: %d", res_3);
            end
        
            out_mod_3 = res_3%MOD_3;
        end
        if (num[WIDTH-1]==1 && out_mod_3!=0) begin
            out_mod_3 = MOD_3 - out_mod_3;
        end
    end
    
    //find fourth mod value
    always @(num)begin
        if(MOD_4%2==0)begin
            case(MOD_4)
                10'b0000000010: out_mod_4 = num[0];
                10'b0000000100: out_mod_4 = num[1:0];
                10'b0000001000: out_mod_4 = num[2:0];
                10'b0000010000: out_mod_4 = num[3:0];
                10'b0000100000: out_mod_4 = num[4:0];
                10'b0001000000: out_mod_4 = num[5:0];
                10'b0010000000: out_mod_4 = num[6:0];
                10'b0100000000: out_mod_4 = num[7:0];
                10'b1000000000: out_mod_4 = num[8:0];
                default: out_mod_4 = 0;
            endcase
        end
        else begin
            res_4 = 0;
            for(j = 0; j<WIDTH-1; j=j+1)begin
//                    num <= num + res_coeff_wire_4[MOD_SIZE*j +: MOD_SIZE]*num[j];
                res_coeff_4 = res_coeff_wire_4[MOD_SIZE*j +: MOD_SIZE];
                res_4 = res_4 + res_coeff_4*num[j];
                $display("mod 3 residues: %d", res_coeff_3);
                $display("reduced residue 3 values: %d", res_4);
            end
            
            out_mod_4 = res_4%MOD_4;
        end
        if (num[WIDTH-1]==1 && out_mod_4!=0) begin
            out_mod_4 = MOD_4 - out_mod_4;
        end
    end
    
endmodule
