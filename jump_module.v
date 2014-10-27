module jump_module(Less,Zero,Condition,Pc,IR, Jump,Ex_offset,pc_in);

input  Less    ,Zero;
input [2:0]    Condition;
input [31:0]   Pc;
input [25:0]   IR;
input          Jump;
input [29:0]   Ex_offset;

output [31:0]  pc_in;

reg [31:0] add_result_1,add_result_2;
reg control_flag [7:0];  


wire [31:0] final_mux_0,final_mux_1;

wire final_mux_7_1;

always@(*)begin 
control_flag[0]=0;
control_flag[7]=1;
add_result_1 = Pc+3'b100;
add_result_2 = {Ex_offset[29:0],{2{1'b0}}}+add_result_1;
control_flag[6]=Less;
control_flag[5]=Less|Zero;
control_flag[4]=~(Less|Zero);
control_flag[3]=~Less;
control_flag[2]=~Zero;
control_flag[1]=Zero;
end 

assign final_mux_1={add_result_1[31:28],IR[25:0],{2{1'b0}}};

assign final_mux_7_1=control_flag[Condition[2:0]];

assign final_mux_0=final_mux_7_1==0?add_result_1:add_result_2;

assign pc_in=Jump==0?final_mux_0:final_mux_1;

endmodule
