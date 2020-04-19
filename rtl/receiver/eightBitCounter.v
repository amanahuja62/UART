`timescale 1ns / 1ps
module counter(
    input reset,clk,up,
    output countReached
    );
	 //countReached becomes 1 when count==8
	 reg [3:0]  count;
	 assign countReached=count[3]&(~count[2])&(~count[1])&(~count[0]);
	 always@(posedge clk, negedge reset)
	 begin
	 if(!reset)
	 count<=4'b0000;
	 else if(up)
	 count<=count+1;
	 
	 end


endmodule
