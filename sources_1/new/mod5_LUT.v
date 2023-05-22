`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 22.12.2022 20:35:42
// Module Name: mod5_LUT: 
// Description: Look-up table for mod 5 values
//////////////////////////////////////////////////////////////////////////////////

module mod5_LUT(
    input [31:0] n,
    output reg [31:0] out
    );
    always @(*) begin
        case(n)
            32'd0: out = 32'd1;
            32'd1: out = 32'd2;
            32'd2: out = 32'd4;
            32'd3: out = 32'd3;
            32'd4: out = 32'd1;
            32'd5: out = 32'd2;
            32'd6: out = 32'd4;
            32'd7: out = 32'd3;
            32'd8: out = 32'd1;
            32'd9: out = 32'd2;
            32'd10: out = 32'd4;
            32'd11: out = 32'd3;
            32'd12: out = 32'd1;
            32'd13: out = 32'd2;
            32'd14: out = 32'd4;
            32'd15: out = 32'd3;
            32'd16: out = 32'd1;
            32'd17: out = 32'd2;
            32'd18: out = 32'd4;
            32'd19: out = 32'd3;
            32'd20: out = 32'd1;
            32'd21: out = 32'd2;
            32'd22: out = 32'd4;
            32'd23: out = 32'd3;
            32'd24: out = 32'd1;
            32'd25: out = 32'd2;
            32'd26: out = 32'd4;
            32'd27: out = 32'd3;
            32'd28: out = 32'd1;
            32'd29: out = 32'd2;
            32'd30: out = 32'd4;
            32'd31: out = 32'd3;
        endcase
    end
endmodule
