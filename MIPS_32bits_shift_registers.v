module MIPS_32bits_shift_registers(Shift_registers_data_in,Shift_amount,Shift_implentation,Shift_registers_data_out_wire);
/*------------------------------------------------------------------------------------------------
输入信号申明：Shift_registers_data_in（输入数据），Shift_amount（移位数目），Shift_implentation（移位类型）
--------------------------------------------------------------------------------------------------*/
input 	[31:0]		Shift_registers_data_in				;
input 	[4:0]			Shift_amount		  					;
input 	[1:0]			Shift_implentation			    	;

/*-----------------------------------------------------------------------------------
输出信号申明：Shift_registers_data_out（移位数据输出）			
-----------------------------------------------------------------------------------*/
output   [31:0]	   Shift_registers_data_out_wire;	
 
 
/*-----------------------------------------------------------------------------------
移位模式参数设置
-----------------------------------------------------------------------------------*/
parameter 		Logic_left_shift		=0		, 		Logic_right_shift			=1;
parameter  Arithmetic_right_shift	=2		,     Rotate_right_shift		=3;

/*-----------------------------------------------------------------------------------
内部寄存器申明
-----------------------------------------------------------------------------------*/
reg   				  [31:0]	Inner_register ;
reg   					Flag						;
reg [31:0]		Shift_registers_data_out			; 
/*-----------------------------------------------------------------------------------
循环用参数申明
-----------------------------------------------------------------------------------*/
integer 					i=0						;
integer              j=0						;
/*-----------------------------------------------------------------------------------	
	主模块申明
-----------------------------------------------------------------------------------*/











always@(Shift_registers_data_in	or	Shift_amount or Shift_implentation)
begin 
   /*----------------------------------------------------------
		移位模式判定
   ------------------------------------------------------------*/
	
	case(Shift_implentation[1:0])
  
				/*--------------------------------------------
               逻辑左移模式
				---------------------------------------------*/
	
  
  Logic_left_shift 			:
									begin 
									   j=Shift_amount[4:0];
										for(i=0;i<32-j;i=i+1)
										   begin
												Inner_register[(i+j)%32]=Shift_registers_data_in[i%32];			
											end 										
										for(i=0;i<j;i=i+1)
										      Inner_register[i]=0;
										
										
									end 
  
				/*--------------------------------------------
					逻辑右移模式
				---------------------------------------------*/
	
  
  Logic_right_shift			: 		
									begin 
                              j=Shift_amount[4:0];
										
										for(i=0;i<32;i=i+1)
											begin 
											   if(i<32&&i>31-j)
													Inner_register[(i+32-j)%32]=0;
									         else 
													Inner_register[(i+32-j)%32]=Shift_registers_data_in[i];		
								
							            end 
						
									end 
  
				/*--------------------------------------------
					算术右移模式
				---------------------------------------------*/
  
  Arithmetic_right_shift	:  
									begin 
									
									   j=Shift_amount[4:0];
										Flag=Shift_registers_data_in[31];
										for(i=0;i<32;i=i+1)
											begin 
											   if(i<32&&i>31-j)
													Inner_register[(i+32-j)%32]=Flag;
									         else 
													Inner_register[(i+32-j)%32]=Shift_registers_data_in[i];		
								
							            end 
                           end 

									
				/*--------------------------------------------
					循环右移模式
				---------------------------------------------*/								
	Rotate_right_shift			:
									begin 
									   j=Shift_amount[4:0];
										for(i=0;i<32;i=i+1)
											Inner_register[(i+32-j)%32]=Shift_registers_data_in[i];
									end 

		endcase 

		
		/*--------------------------------------------
					输出赋值
		---------------------------------------------*/
		Shift_registers_data_out[31:0]=Inner_register[31:0];


end 
       assign Shift_registers_data_out_wire=Shift_registers_data_out;
		/*--------------------------------------------
					模块结束
		---------------------------------------------*/

endmodule 