`timescale 1ns / 1ps
module RX_fsm(input zeroDetected,oneDetected,parityError,clk,reset,countReached,
output reg shift,startCount,resetCounter,outputEnable);

//fsm states
parameter idle=2'b00,data=2'b01,parityCheck=2'b10,stopCheck=2'b11; 
reg[1:0] nextState,state;



always@(*)
begin
case(state)
idle:if(zeroDetected)nextState=data;
     else nextState=idle;      
data: if(countReached) nextState=parityCheck; 
      else nextState=data; 
parityCheck: if(parityError)nextState=idle;
             else nextState=stopCheck;
				
stopCheck:nextState=idle;
default: nextState=idle;
endcase
end

always@(posedge clk, negedge reset)
begin
if(!reset) 
state<=idle;
else
state<=nextState;
end

always@(*)
begin
shift=0; startCount=0; resetCounter=1; outputEnable=0;

case(state)
idle: begin  if(zeroDetected)  startCount=1;                             
                               
				 else resetCounter=0;
		end
data:  begin startCount=1;
        shift=1; 
 		 end
stopCheck: begin if(oneDetected) 
           outputEnable=1;
			  end
default: begin shift=0;  startCount=0;
         resetCounter=1; outputEnable=0;
 			end
endcase

end



endmodule
