`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 06.04.2023 16:57:39
//////////////////////////////////////////////////////////////////////////////////

module tb_v_1();
     wire [8:0] bit_sum;
     reg [31:0] n;
     
     reg [4:0] res, res_correct;
     reg error;
     integer f;
     
    initial begin
        f = $fopen("output.txt","w");
        for (n = 0; n<= 32'h00ffffff; n=n+1)begin
            #1;
            $fwrite(f,"%d ",bit_sum);
            $fwrite(f,"\n");
//            res = bit_sum%21;
//            res_correct = n%21;
//            if(res == res_correct)
//                error = 0;
//            else
//                error = 1;
        end
        $fclose(f);
    end
    
    mod_21_v_1 DUT(bit_sum, n);
endmodule
