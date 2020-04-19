`timescale 1ns / 1ps
module Txmux(input s1,s0,i0,i1,i2,i3,output y);
assign y=({s1,s0}==(2'b00))?(i0):({s1,s0}==(2'b01))?(i1):({s1,s0}==(2'b10))?(i2):(i3);
endmodule
