`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 06.04.2023 16:57:39
//////////////////////////////////////////////////////////////////////////////////

module tb_v_2();
     wire [8:0] bit_sum;
     wire [6:0] final;
     reg [31:0] n;
     
     integer f;
     
    initial begin
        f = $fopen("output1.txt","w");
        for (n = 0; n<= 32'h0000ffff; n=n+1)begin
            #1;
            $fwrite(f,"%d ",bit_sum);
            $fwrite(f,"\n");
        end
        $fclose(f);
    end
    
    mod_21_v_2 DUT(bit_sum, final, n);
endmodule
