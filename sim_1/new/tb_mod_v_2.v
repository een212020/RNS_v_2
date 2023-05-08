`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 16.04.2023 16:57:39
//////////////////////////////////////////////////////////////////////////////////

module tb_mod_v_2();
     wire [7:0] sum;
     
     wire [6:0] f_sum;
     reg [15:0] n;
     
     integer f;
     
    initial begin
    n = 32'hffff;
//        for (n = 0; n<= 32'hffff; n=n+1)begin
//            #1;
//        end
    end
    
    //mod_gen_v_2 DUT(n, sum, f_sum);
endmodule
