`timescale 1ns / 1ps
module detectStart(input data,clk,mainclock,output  startDetected);
reg[7:0] ffs;
assign startDetected=~|ffs;
always@(posedge clk)
if(mainclock)
ffs<={data,ffs[7:1]};
endmodule