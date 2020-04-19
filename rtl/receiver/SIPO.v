`timescale 1ns / 1ps
module SIPO(input oneDetected,zeroDetected,baudClock,shift,output reg [7:0] outdata);
//serial in parallel out shift Register
always@(posedge baudClock)
begin
if(shift&oneDetected)
outdata<={1'b1,outdata[7:1]};
else if(shift&zeroDetected)
outdata<={1'b0,outdata[7:1]};
end

endmodule
