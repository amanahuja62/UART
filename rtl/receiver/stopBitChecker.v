`timescale 1ns / 1ps
module bitChecker(input data,clk,mainclock,output zeroDetected, oneDetected);
//mainClock is the baudClock
//clk is higher frequency clock used for sampling data
reg[3:0] ffs;
assign oneDetected=&ffs;
assign zeroDetected=~|ffs;
always@(posedge clk)
if(mainclock)
ffs<={data,ffs[3:1]};
endmodule
