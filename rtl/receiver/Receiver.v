`timescale 1ns / 1ps
module Receiver(input datain,clk,reset,output[7:0] dataOut);
// datain is the input serial data from the transmitter
//reset is asynchronous. // when reset=0 reciever goes in idle state
//dataOut is the parallel output data

//internal signals used by fsm
//if shift==1 shift register shifts to the right and MSB of the shiftRegister becomes datain(serial input data)
// when startDetected becomes 1, it means start bit has been detected
// when stopDetected becomes 1, it means that stop has been detected
// when parityError=1, it means there is error in the data, receiver then enters
// into idle state(in the next posedge of baudClock)
// when oneDetected==1, it means 1 has been detected in the datain(serial input Data)
wire shift,startDetected,parityError,oneDetected,zeroDetected;
reg[2:0] c;
wire[7:0] outdata;
wire[3:0] count;
wire baudClock;
wire startCount,resetCounter,countReached,outputEnable;
wire[3:0] ffs;

assign dataOut=(outputEnable)?(outdata):(8'bZ);

///////////////code to frequency of clk by 8////////////////////////////
always@(negedge clk, negedge reset)begin 
if(~reset)
c<=0;
else 
c<=c+1;
end
assign baudClock=(c[2]=='b1);

//Receiver has five parts-------
//1) FSM
//2)SIPO (serial in parallel out)
//3)bitChecker (checks whether serial input data is 0 or 1 by using high frequency clock for 
//sampling,i.e, clk input)
//4) counter: used by fsm to stay in data receiving state for eight consecutive cycles
//5)parity checker: used for checking the error in received data

RX_fsm fsm(.zeroDetected(zeroDetected),
.oneDetected(oneDetected),
.parityError(parityError),
.clk(baudClock),
.reset(reset),
.startCount(startCount),
.resetCounter(resetCounter),
.shift(shift),
.countReached(countReached),
.outputEnable(outputEnable));

SIPO sipo(.oneDetected(oneDetected),
.zeroDetected(zeroDetected),
.baudClock(baudClock),
.shift(shift),
.outdata(outdata));

bitChecker bitChecker(.data(datain),
.clk(clk),
.mainclock(baudClock),
.oneDetected(oneDetected),
.zeroDetected(zeroDetected));

counter counter1(.reset(resetCounter),
.clk(baudClock),
.up(startCount),
.countReached(countReached));

parityChecker pchecker(outdata,zeroDetected, oneDetected,parityError);

endmodule
