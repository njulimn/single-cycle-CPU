module Mips_single_round_CPU(
		 clk,
		 
		 pc_in ,
		 
		 pc_out ,
		 
     	 IR_out,

		 Jump_out,Ex_top_out,ALU_shift_sel_out,Shift_amounsrc_out,Regdst_out,Overflow_out,Regdto_out,

       Shift_op_out,ALU_srcB_out,

       condition_out,

       ALU_op_out ,Rd_write_byte_en_out ,

       B_in_out,

       Rs_addr_out ,Rt_addr_out,Rd_addr_out,Rd_in_out,Rs_out_out,Rt_out_out,

       Imm_ex_out,Ex_offset_out,


       ALU_out_out,
       Zero_out,Less_out,

       Shift_amount_out,

       Shift_out_out
);

input 					clk;
output reg  [31:0]   pc_out ;
output      [31:0]   pc_in;
wire        [31:0]  	 IR;

wire     Jump,Ex_top,ALU_shift_sel,Shift_amounsrc,Regdst,Regdto;

wire     [1:0]  Shift_op ,ALU_srcB;

wire     [2:0]  condition;
wire  	[3:0]  ALU_op ,Rd_write_byte_en ;

wire     [31:0] B_in;


wire     [31:0] Rs_addr ,Rt_addr,Rd_addr,Rd_in,Rs_out,Rt_out;

wire     [31:0] Imm_ex,Ex_offset;


wire  	[31:0] 	ALU_out;
wire  	Zero,Less;

wire     [4:0]   Shift_amount;

wire  	[31:0]  Shift_out;


/*---------------------------------
   DEBUG module  
----------------------------------*/
output         [31:0]  	 IR_out;

output    		Jump_out,Ex_top_out,ALU_shift_sel_out,Shift_amounsrc_out,Regdst_out,Regdto_out;

output    		[1:0]  	Shift_op_out,ALU_srcB_out;

output      	[2:0]  	condition_out;

output  			[3:0]  	ALU_op_out ,Rd_write_byte_en_out ;

output      	[31:0] 	B_in_out;

output      	[31:0] 	Rs_addr_out ,Rt_addr_out,Rd_addr_out,Rd_in_out,Rs_out_out,Rt_out_out;

output      	[31:0] 	Imm_ex_out,Ex_offset_out;


output   		[31:0] 	ALU_out_out;
output      	 Zero_out,Less_out,Overflow_out;

output      	[4:0]   Shift_amount_out;

output  	   	[31:0]  Shift_out_out;

/*---------------------------------*/

initial
begin
pc_out=32'b0;
end



I_mm_read  p2 (	pc_out,   IR);

assign  Rs_addr=IR[25:21];

cpu_control a0 (IR, Jump, Shift_op,	Ex_top,	Shift_amounsrc, Regdst,	ALU_op, ALU_shift_sel,	condition,	ALU_srcB,Overflow,Rd_write_byte_en,	Regdto);

assign Rt_addr=Regdto==0?IR[20:16]:5'b00000;
assign Rd_addr=Regdst==0?IR[20:16]:IR[15:11];
		  

		  
Mips_32bits_registers		a1					 (clk ,Rs_addr,Rt_addr,Rd_addr,Rd_in,Rd_write_byte_en,Rs_out,Rt_out);


ex_module						a2					 (IR[15:0],Ex_top,Imm_ex,Ex_offset);




assign B_in=ALU_srcB==0?Rt_out:{ALU_srcB==1?Ex_offset:Imm_ex};

Mips_32bits_ALU				a3					 (Rs_out,B_in,ALU_op,ALU_out,Zero,Less,Overflow);

jump_module						a4					 (Less,Zero,condition,pc_out, IR, Jump,Ex_offset,pc_in);

				 
assign Shift_amount=Shift_amounsrc==0?IR[10:6]:Rs_out[4:0];
				 
				 
MIPS_32bits_shift_registers a5				 (Rt_out,Shift_amount,Shift_op,Shift_out);


assign  Rd_in=ALU_shift_sel==0?ALU_out:Shift_out ;     



/*--------------------------------------
output moduel  
----------------------------------------*/
assign      IR_out=IR;

assign      Jump_out=Jump;

assign      Ex_top_out=Ex_top;

assign 		ALU_shift_sel_out=ALU_shift_sel;

assign 		Shift_amounsrc_out=Shift_amounsrc;
assign 		Regdst_out=Regdst;
assign 		Overflow_out=Overflow;
assign 		Regdto_out=Regdto;

assign      Shift_op_out=Shift_op;
assign 		ALU_srcB_out=ALU_srcB;
assign      condition_out=condition;

assign      ALU_op_out=ALU_op ;
assign 		Rd_write_byte_en_out=Rd_write_byte_en ;
assign      B_in_out=B_in;
assign      Rs_addr_out=Rs_addr;
assign  		Rt_addr_out=Rt_addr;
assign 		Rd_addr_out=Rd_addr;
assign 		Rd_in_out=Rd_in;
assign      Rs_out_out=Rs_out;
assign 		Rt_out_out=Rt_out;

assign  		 Imm_ex_out=Imm_ex;
assign   	 Ex_offset_out=Ex_offset;


assign    	 ALU_out_out=ALU_out;
assign       Zero_out=Zero;
assign  		 Less_out=Less;
assign 		 Overflow_out=Overflow;
assign       Shift_amount_out=Shift_amount;
assign   	 Shift_out_out=Shift_out;


/*-----------------------------------------
Pc寄存器更新
------------------------------------------*/



always@(posedge clk)
begin 
pc_out=pc_in;
end 


endmodule
