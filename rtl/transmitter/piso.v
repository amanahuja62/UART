`timescale 1ns / 1ps
module piso(input[7:0] datain,input shift,load,clk,output reg outdata);
reg[7:0] intFF;


always@(posedge clk)
begin

if(load)
intFF<=datain;
else if(shift) 
begin
outdata<=intFF[0];
intFF<=intFF>>1;
end 
end
endmodule
 