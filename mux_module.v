



module Mux_16bits(control_signal,Data_in_A,Data_in_B,Data_out);
 input 			control_signal;
 input  [15:0] 	Data_in_A,Data_in_B;
 output [15:0]  Data_out;
 assign  Data_out=control_signal==0?Data_in_A:Data_in_B;
endmodule


module Mux_32_2bits(control_signal,Data_in_A,Data_in_B,Data_out);
 input 			control_signal;
 input  [31:0] 	Data_in_A,Data_in_B;
 output [31:0]  	Data_out;
 assign  Data_out=control_signal==0?Data_in_A:Data_in_B;
endmodule

module Mux_32_3bits(control_signal,Data_in_A,Data_in_B,Data_in_C,Data_out);
 input  [1:0]  control_signal;
 input  [4:0] 	Data_in_A,Data_in_B,Data_in_C;
 output [4:0]  Data_out;
 assign  Data_out=control_signal==0?Data_in_A:{control_signal==1?Data_in_B:Data_in_C};
endmodule


