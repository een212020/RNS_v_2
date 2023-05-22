//Date: 14th December, 2022
//Converts Binary number to mod(8,7,5,3) RNS value
///////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module BIN2RNS_mod_LUT(
    //inputs clock and number whose residue is to  be found
    input clk, [9:0] n,
    //outputs mod 8,7,5,3
    output reg [2:0] mod8,  mod7, mod5,
    output reg [1:0] mod3
    );
    //temporary registers to hold reduced residue values
    reg [2:0] num8;
    reg [4:0] num7, num5;
    reg [3:0] num3;
    reg [9:0] num;
    
    //check if number is positive or negative
    //if negative take 2's complement of number to find the equivalent positive number 
    //and use num[9] as flag
     always @(n) begin
        num = n;
        if(num[9]==1) begin
            num = 1024 - num;
            num[9] = 1;
        end
     end
     //find reduced residues 
     always @(posedge clk) begin
        num7 <= (num[0]+num[3]+num[6]) + 2*(num[1]+num[4]+num[7]) + 4*(num[2]+num[5]+num[8]);
        num5 <= (num[0]+num[4]+num[8]) + 2*(num[1]+num[5]) + 4*(num[2]+num[6]) + 3*(num[3]+num[7]);
        num3 <= (num[0]+num[2]+num[4]+num[6]+num[8]) + 2*(num[1]+num[3]+num[5]+num[7]);
        num8 <= num[2:0];
    end    
    //find mod 3 value
    always @(num3)begin
        if (num3 < 3) mod3 = num3;
        else if (num3 < 6) mod3 = num3 - 3;
        else if (num3 < 9) mod3 = num3 - 6;
        else if (num3 < 12) mod3 = num3 - 9;
        else if (num3 < 15) mod3 = num3 - 12;
        else mod3 = 0;
        //if number is negative and mod 3 value found is non-zero, 
        //find the mod 3 value for the absolute value of the number
        if (num[9]==1 && mod3!=0) begin
            mod3 = 3 - mod3;
        end
    end
    //find mod 5 value
    always @(num5)begin
        if (num5 < 5) mod5 = num5;
        else if (num5 < 10) mod5 = num5 - 5;
        else if (num5 < 15) mod5 = num5 - 10;
        else if (num5 < 20) mod5 = num5 - 15;
        else if (num5 < 25) mod5 = num5 - 20;
        else mod5 = 0;
        
        if (num[9]==1 && mod5!=0) begin
            mod5 = 5 - mod5;
        end        
    end
    //find mod 7 value
    always @(num7)begin
        if (num7 < 7) mod7 = num7;
        else if (num7 < 14) mod7 = num7 - 7;
        else if (num7 < 21) mod7 = num7 - 14;
        else if (num7 < 28) mod7 = num7 - 21;
        else mod7 = 0;
        
        if (num[9]==1 && mod7!=0) begin
            mod7 = 7 - mod7;
        end        
    end
    //find mod8 value
    always @(num8)begin
        if (num[9]==1 && num8!=0)
            mod8 = 8 - num8;
        else 
            mod8 = num8;
    end
endmodule
