module ex_module(IR,Ex_top,Imm_ex,Ex_offset);
input [15:0] IR;
input Ex_top;
output [31:0] Imm_ex,Ex_offset;

assign  Ex_offset=Ex_top==0?{{16{1'b0}},IR[15:0]}:{{16{IR[15]}},IR[15:0]};
assign  Imm_ex={IR[15:0],{16{1'b0}}};  

endmodule


