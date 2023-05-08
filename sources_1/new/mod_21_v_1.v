`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 05.04.2023 21:15:03
//////////////////////////////////////////////////////////////////////////////////


module mod_21_v_1(
    tot, 
    n
    );
    input [31:0] n;
    output [8:0] tot;
    
    wire [11:0] s_1;
    wire [5:0] c_1_1;
    wire [5:0] c_1_2;
    wire [5:0] s_2, c_2;
    wire [5:0] s_3, c_3;
    
    wire [5:0] cp;
    
    wire [1:0] temp;
    
    //g0
    FA st1_g0_fa1(c_1_1[0], s_1[0], n[0], n[6], n[12]);
    FA st1_g0_fa2(c_1_2[0], s_1[1], n[18], n[24], n[30]);
    
    FA st2_g0_fa1(c_2[0], s_2[0], s_1[1], 0, s_1[0]);
    
    FA st3_g0_fa1(c_3[0], s_3[0], 0, 0, s_2[0]);
    
    //g1
    FA st1_g1_fa1(c_1_1[1], s_1[2], n[1], n[7], n[13]);
    FA st1_g1_fa2(c_1_2[1], s_1[3], n[19], n[25], n[31]);
    
    FA st2_g1_fa1(c_2[1], s_2[1], s_1[3], c_1_1[0], s_1[2]);
    
    FA st3_g1_fa1(c_3[1], s_3[1], c_1_2[0], c_2[0], s_2[1]);
    
    //g2
    FA st1_g2_fa1(c_1_1[2], s_1[4], n[2], n[8], n[14]);
    FA st1_g2_fa2(c_1_2[2], s_1[5], 0, n[20], n[26]);
    
    FA st2_g2_fa1(c_2[2], s_2[2], s_1[5], c_1_1[1], s_1[4]);
    
    FA st3_g2_fa1(c_3[2], s_3[2], c_1_2[1], c_2[1], s_2[2]);
    
    //g3
    FA st1_g3_fa1(c_1_1[3], s_1[6], n[3], n[9], n[15]);
    FA st1_g3_fa2(c_1_2[3], s_1[7], 0, n[21], n[27]);
    
    FA st2_g3_fa1(c_2[3], s_2[3], s_1[7], c_1_1[2], s_1[6]);
    
    FA st3_g3_fa1(c_3[3], s_3[3], c_1_2[2], c_2[2], s_2[3]);
    
    //g4
    FA st1_g4_fa1(c_1_1[4], s_1[8], n[4], n[10], n[16]);
    FA st1_g4_fa2(c_1_2[4], s_1[9], 0, n[22], n[28]);
    
    FA st2_g4_fa1(c_2[4], s_2[4], s_1[9], c_1_1[3], s_1[8]);
    
    FA st3_g4_fa1(c_3[4], s_3[4], c_1_2[3], c_2[3], s_2[4]);
    
    //g5
    FA st1_g5_fa1(c_1_1[5], s_1[10], n[5], n[11], n[17]);
    FA st1_g5_fa2(c_1_2[5], s_1[11], 0, n[23], n[29]);
    
    FA st2_g5_fa1(c_2[5], s_2[5], s_1[11], c_1_1[4], s_1[10]);
    
    FA st3_g5_fa1(c_3[5], s_3[5], c_1_2[4], c_2[4], s_2[5]);
    
    //CPA
    assign tot[0] = s_3[0];
    FA f0(cp[0], tot[1], 0, c_3[0], s_3[1]);
    FA f1(cp[1], tot[2], cp[0], c_3[1], s_3[2]);
    FA f2(cp[2], tot[3], cp[1], c_3[2], s_3[3]);
    FA f3(cp[3], tot[4], cp[2], c_3[3], s_3[4]);
    FA f4(cp[4], tot[5], cp[3], c_3[4], s_3[5]);
    FA f5(cp[5], temp[0], cp[4], c_3[5], c_2[5]);
    FA f6(temp[1], tot[6], temp[0], c_1_2[5], c_1_1[5]);
    FA f7(tot[8], tot[7], 0, cp[5], temp[1]);
    
endmodule
