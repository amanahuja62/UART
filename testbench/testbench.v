`timescale 1ns / 1ps
module testbench;

	// Inputs
	reg TXStart;	
	reg reset;
	reg [7:0] datain;
   reg samplingClock; 
	wire TXdataOut; 
   wire[7:0] dataOut;
	


	initial samplingClock=0;
	
	transmitter uut (
		.TXStart(TXStart),  
		.clk2(samplingClock),  
		.reset(reset), 
		.datain(datain),  
		.TXdataOut(TXdataOut)
	
		
	); 
	Receiver uut2 (TXdataOut,samplingClock,reset,dataOut);
   
	initial begin
	reset=0;  // active low asynchronous reset
	#1 reset=1;
	#18 TXStart=1; datain=8'b10010101; // TXStart makes the transmitter go the the start state. dataIn is the 
		                           // eight bit data to be transmitted serially
	#944 datain=8'b10111001; 
	#944 datain=8'b11000011;
	#944 datain=8'b11001100;
	 

	end
	
	always #5
	samplingClock=~samplingClock;
	
      
endmodule

