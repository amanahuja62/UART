`timescale 1ns / 1ps
`define startBit 1'b0;
`define stopBit 1'b1;
module transmitter(input TXStart,clk2,reset,input[7:0] datain,output  TXdataOut);
//when TXstart=1 transmitter begins its transmission by sending start bit
//when reset=0(active low) transmitter becomes idle
//datain is the eight bit data to be transmitted serially
//TXdataOut is the serial output data
wire shift,load,s1,s0,parityBit,dataOut,startCounter,resetCounter,countReached,clk;
///////////////code to frequency of clk2 by 8////////////////////////////
reg[2:0] c;
always@(negedge clk2, negedge reset)begin
if(~reset)
c<=0;
else 
c<=c+1;
end
assign clk=(c[2]=='b1);  //frequency of clk=freq of clk2/8 

////////////trasnsmitter contains five parts-----
//1) FSM
//2)PISO (parallel in serial out shift register)
//3)Parity Generator (It generates the parity bit for the inputData)
//4)4X1 MUX (Its select lines decide whether the ouput should be startBit,data,parity or stopBit)
//5)Counter (It is used by fsm so that it can stay in the "data sending state" for eight consecutive clock cycles)


TXfsm fsm(.TXStart(TXStart),
.clk(clk),
.reset(reset),
.countReached(countReached),
.shift(shift),
.load(load),
.s1(s1),
.s0(s0),
.startCounter(startCounter),
.resetCounter(resetCounter)
);

piso mypiso(.datain(datain),
.shift(shift),
.load(load),
.clk(clk),
.outdata(dataOut));

paritygen pargen(.inputdata(datain),
.load(load),
.parity(parityBit));


Txmux mux(.s1(s1),
.s0(s0),
.i0(1'b0),
.i1(dataOut),
.i2(parityBit),
.i3(1'b1),
.y(TXdataOut));

counter counter1(.reset(resetCounter),
.clk(clk),
.up(startCounter),
.countReached(countReached));



endmodule
  