`timescale 1ns / 1ps
module paritygen(input[7:0] inputdata, input load,output reg parity);
always@(load,inputdata)
begin 
if(load)
parity=^inputdata;

end


endmodule
