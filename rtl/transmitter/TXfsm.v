`timescale 1ns / 1ps
module TXfsm(input TXStart,clk,reset,countReached,output reg shift,load,s1,s0,startCounter,resetCounter);
//when load==1 in the next positive edge of clk, shiftRegister is loaded with inputData
//when shift==1 in the next positive edge of clk, lsb of shift register is transmitted via TXdataOut and
//shift Register is shifted towards right
//s1 and s0 are select lines which decide the output of 4*1 mux
//when resetCounter=1 counter becomes zero(Asynchronous reset)
//when startCounter=1 counter increments its count in the next positive edge of the clk

///////////////fsm states///////////////////
parameter idle=3'b000, start=3'b001, data=3'b010, parity=3'b011, stop=3'b100;
reg[2:0] c_state; //current state
reg[2:0] n_state;  //next state



always@(posedge clk,negedge reset)
begin
if(!reset)
c_state<=idle;
else
c_state<=n_state;
end

always@(*)
begin
case(c_state)
idle:n_state=(TXStart)?(start):(idle);
start:n_state=data;
data:  if(countReached) n_state=parity;
       else n_state=data;
parity: n_state=stop;
stop:   n_state=idle;
default: n_state=idle;
endcase
end



always@(*)
begin
load=0; shift=0; startCounter=0; resetCounter=1;
case(c_state)
idle:begin s1=1; s0=1; 
       if(TXStart) begin load=1;resetCounter=0; 
                   end 
       end
start: begin s1=0; s0=0; 
				 shift=1; 
				 startCounter=1;
       end
data: begin s1=0; s0=1; 
            if(~countReached) begin 
            startCounter=1; shift=1;
			   end 
      end
parity:begin s1=1; 
             s0=0;
       end
stop: begin s1=1; s0=1;
      end
default: begin s1=1; s0=1; 
               load=0; shift=0; 
					startCounter=0; resetCounter=1; 
         end
endcase
end

endmodule
