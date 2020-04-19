`timescale 1ns / 1ps
module parityChecker(input [7:0] inputData,input zeroDetected, oneDetected,output reg parityError);
//after receiving the serial data and storing it in sipo
//inputData is the parallel data output from sipo
wire parity=^inputData;
always@(*)
begin
if(parity&zeroDetected|(~parity)&oneDetected)
parityError=1;
else
parityError=0;
end

endmodule
