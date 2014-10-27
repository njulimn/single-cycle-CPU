module Mips_32bits_registers(clk, Rs_addr,Rt_addr,Rd_addr,Rd_in,Rd_Byte_w_en,Rs_out_wire,Rt_out_wire);
/*-------------------------------------------------------------------------------------------------
输入信号   	/-read   输入信号： 	Rs_addr（读出地址）,Rt_addr（读出地址）,read_en（输入有效信号）-/
				/- write 输入信号: 	Rd_addr（写入地址） Rd_Byte_w_en（写入字节控制信号），Rd_in（写入数据信号）
			    	Read_en(输入有效信号) -/
--------------------------------------------------------------------------------------------------*/
input [4:0] 	Rs_addr,Rt_addr,Rd_addr;
input [3:0] 	Rd_Byte_w_en;
input [31:0]	Rd_in ;
input clk;


/*-------------------------------------------------------------------------------------------------
    输出信号 /-Rs_out 数据输出信号 Rt_out 数据输出信号 -/ 
              	 
--------------------------------------------------------------------------------------------------*/

output  [31:0] Rs_out_wire,Rt_out_wire;
reg  	  [31:0] Rs_out,Rt_out;
reg     [31:0] Registers [31:0];
/*-------------------------------------------------------------------------------------------------
   初始化模块（0号寄存器的初始化）
--------------------------------------------------------------------------------------------------*/
 initial begin 
       Registers[0][31:0]=32'd0;
       Registers[1][31:0]=32'd1;
		 Registers[2][31:0]=32'd2;
		 Registers[3][31:0]=32'd3;
		 
		 Registers[4][31:0]=32'd4;
       Registers[5][31:0]=32'd5;
		 Registers[6][31:0]=32'd6;
		 Registers[7][31:0]=32'd7;
		  
		 Registers[8][31:0]=32'd8;
       Registers[9][31:0]=32'd9;
		 Registers[10][31:0]=32'd10;
		 Registers[11][31:0]=32'd11;
		  
		 Registers[12][31:0]=32'd12;
       Registers[13][31:0]=32'd13;
		 Registers[14][31:0]=32'd14;
		 Registers[15][31:0]=32'd15;
		 
		 Registers[16][31:0]=32'd16;
       Registers[17][31:0]=32'd17;
		 Registers[18][31:0]=32'd18;
		 Registers[19][31:0]=32'd19;
		   
		 Registers[20][31:0]=32'd20;
       Registers[21][31:0]=32'd21;
		 Registers[22][31:0]=32'd22;
		 Registers[23][31:0]=32'd23;
		  
		 Registers[24][31:0]=32'd24;
       Registers[25][31:0]=32'd25;
		 Registers[26][31:0]=32'd26;
		 Registers[27][31:0]=32'd27;
		  
		 Registers[28][31:0]=32'd28;
       Registers[29][31:0]=32'd29;
		 Registers[30][31:0]=32'd30;
		 Registers[31][31:0]=32'd31;
		   

		 end 

/*-------------------------------------------------------------------------------------------------
   主模块（写入与读出）
--------------------------------------------------------------------------------------------------*/ 

always@(posedge clk)
	begin
   /*--------------------
     写入模块
   ---------------------*/
   if((Rd_addr!=0))	begin 
   	   if(Rd_Byte_w_en[0])
		   Registers[Rd_addr][7:0]=Rd_in[7:0];
			if(Rd_Byte_w_en[1])
		   Registers[Rd_addr][15:8]=Rd_in[15:8];
			if(Rd_Byte_w_en[2])
		   Registers[Rd_addr][23:16]=Rd_in[23:16];
			if(Rd_Byte_w_en[3])
		   Registers[Rd_addr][31:24]=Rd_in[31:24];
					   end
	
	end
	
always@(*)
begin
/*--------------------
     读出模块
   ---------------------*/
					begin 
	            Rs_out=Registers[Rs_addr];
			      Rt_out=Registers[Rt_addr];		
					end 
end 
	
	
	
	
	assign Rs_out_wire=Rs_out;
	assign Rt_out_wire=Rt_out;
	
	
endmodule 