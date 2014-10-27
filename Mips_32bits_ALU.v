module Mips_32bits_ALU(Data_in_A,Data_in_B,ALU_op,ALU_out_wire,Zero,Less,Overflow_out);
/*-------------------------------------------------------------
输入信号声明，包含数据输入，以及操作码输入
--------------------------------------------------------------*/
input 	[31:0]	Data_in_A,Data_in_B;
input  	[3:0]		ALU_op				 ;
/*--------------------------------------------------------------
内部寄存器组以及线路声明模块
---------------------------------------------------------------*/
reg      [31:0] 	Inner_registers [7:0]; 
reg      [31:0]   ALU_out;
wire       zero ,	carry	, 		overflow		, 	negative ; 
wire      [31:0] Inner_wire1,Inner_wire2 ;
/*--------------------------------------------------------------
数据输出（ALU_out）以及标志位输出Zero ,	Less,Overflow_out;
---------------------------------------------------------------*/
output     [31:0]	 ALU_out_wire				;
output   			Zero ,	Less,			Overflow_out;
/*--------------------------------------------------------------
调用ALU模块处理所有加减法问题；
---------------------------------------------------------------*/
ALU 					module_1  		(ALU_op[0],Data_in_A,Data_in_B,Inner_wire1,zero,carry,overflow,negative);
/*--------------------------------------------------------------
调用处理前导0/1问题，计算前导0/1个数；
---------------------------------------------------------------*/
pre_continue_0_1  module_2 (ALU_op[0],Data_in_A,Inner_wire2);

/*--------------------------------------------------------------
连线型处理标志位输出
---------------------------------------------------------------*/
assign Less=(ALU_op[3:0]==0111)?(!carry):(overflow^negative);
assign Zero=zero;
assign Overflow_out=(ALU_op[3:0]==0111)?overflow:0;
/*--------------------------------------------------------------
主模块
---------------------------------------------------------------*/
always@(*)
	begin
			/*--------------------------------------------------------------
			记录ALU模块以及前导0/1计数模块处理结果
			---------------------------------------------------------------*/	
	    Inner_registers[7][31:0]=Inner_wire1[31:0];
		 Inner_registers[0][31:0]=Inner_wire2[31:0];
       	/*--------------------------------------------------------------
			 sltu/sltui/slt/slti指令的输出处理
			---------------------------------------------------------------*/	 
				 if(Less==1)
					Inner_registers[5][31:0]=32'b11111111111111111111111111111111;
				else 
				   Inner_registers[5][31:0]=32'b00000000000000000000000000000000;
			/*--------------------------------------------------------------
			 根据操作码处理输出
			---------------------------------------------------------------*/	 							
		case(ALU_op[3:0])
		    /*-----------------------------------
				无符号加减输出处理
			 -------------------------------------*/
				4'b0000:	                              
							ALU_out[31:0]=Inner_registers[7][31:0];
				4'b0001:	
							ALU_out[31:0]=Inner_registers[7][31:0];
			 /*-----------------------------------
				前导0/1输出处理模块
			 -------------------------------------*/
			 
				4'b0010:  
							ALU_out[31:0]=Inner_registers[0][31:0];
				4'b0011:
			            ALU_out[31:0]=Inner_registers[0][31:0];
			 
			 /*-----------------------------------
				与操作输出处理
			 -------------------------------------*/
				4'b0100:   	
							begin 
							Inner_registers[4][31:0]=(Data_in_A&Data_in_B);
							ALU_out[31:0]=Inner_registers[4][31:0];		
							end 
			 /*-----------------------------------
				slt/slti输出处理
			 -------------------------------------*/
			  4'b0101:   ALU_out[31:0]=Inner_registers[5][31:0];
			 /*-----------------------------------
				或操作处理
			 -------------------------------------*/
			 
			  4'b0110:  	begin 
							Inner_registers[2][31:0]=(Data_in_A|Data_in_B);
							ALU_out[31:0]=Inner_registers[2][31:0];		
							end 
			 /*-----------------------------------
				sltu/sltiu操作输出处理
			 -------------------------------------*/
			 4'b0111:	ALU_out[31:0]=Inner_registers[5][31:0];
			 /*-----------------------------------
				或非操作输出处理
			 -------------------------------------*/
			 4'b1000: 	begin
							Inner_registers[3][31:0]=~(Data_in_A|Data_in_B);
							ALU_out[31:0]=Inner_registers[7][31:0];	
							end 
			 /*-----------------------------------
				异或操作输出处理
			 -------------------------------------*/
			 4'b1001: 	begin 
							 Inner_registers[1][31:0]=Data_in_A^Data_in_B;
						    ALU_out[31:0]=Inner_registers[1][31:0];	
							end 
			 /*-----------------------------------
			 SEB操作处理
			 -------------------------------------*/
			 4'b1010: begin 
							 Inner_registers[6][31:0]={{24{Data_in_B[7]}},Data_in_B[7:0]};
						    ALU_out[31:0]=Inner_registers[6][31:0];	
						 end 			 
			 /*-----------------------------------
				SEH输出处理
			 -------------------------------------*/
			 4'b1011: begin 
							 Inner_registers[6][31:0]={{16{Data_in_B[15]}},Data_in_B[15:0]};
						    ALU_out[31:0]=Inner_registers[6][31:0];	
						 end 									 
			 
			 /*-----------------------------------
				有符号加减输出处理
			 -------------------------------------*/
			 4'b1110:
							ALU_out[31:0]=Inner_registers[7][31:0];
			
			 4'b1111:
							ALU_out[31:0]=Inner_registers[7][31:0];
		
		endcase
end 		

assign ALU_out_wire=ALU_out;	
			
endmodule 





/*-----------------------------------
	用于加减计算的ALU模块
-------------------------------------*/
module  ALU(cin,Data_in_A,Data_in_B,Data_out,zero,carry,overflow,negative);
input 														cin		;
input 	[31:0]	Data_in_A,	Data_in_B						;
reg   	[31:0]   Data_temp,	Data_B_not						;
output   reg [31:0]   Data_out;
output   	zero 	,	carry		,overflow	,negative	;
always@(*)
begin
	if(cin==1)
		
					Data_B_not=Data_in_B^32'b11111111111111111111111111111111;
	else 
					Data_B_not=Data_in_B;
	Data_temp=Data_B_not+cin;
	Data_out=Data_temp+Data_in_A;

end 

assign zero=(Data_out==32'b0)?1:0;
assign negative=(Data_out[31]==1)?1:0;
assign carry=((Data_in_A[31]&&Data_in_B[31])||(Data_in_A[31]&&!Data_out[31])||(Data_in_B[31]&&!Data_out[31]))?1:0;
assign overflow=((!Data_in_A[31]&!Data_B_not[31]&Data_out[31])||(Data_in_A[31]&Data_B_not[31]&!Data_out[31]));
endmodule 




/*-----------------------------------
	前导0/1的计算模块
-------------------------------------*/
module pre_continue_0_1(cin,Data_in_A,Data_out_module_pre_continue);

input  cin;
input  [31:0] Data_in_A;

reg    [31:0] Data_for_tem;

integer i;

output reg  [31:0] Data_out_module_pre_continue;

always@(*)
begin 
if(cin==1)
	Data_for_tem=Data_in_A^32'b11111111111111111111111111111111;
else 
   Data_for_tem=Data_in_A^32'b00000000000000000000000000000000;
	i=0;
while(Data_for_tem!=0)
	begin 
	Data_for_tem[31:0]={1'b0,Data_for_tem[31:1]};
	i=i+1;
	end 
	Data_out_module_pre_continue=(32-i);
end 
endmodule 