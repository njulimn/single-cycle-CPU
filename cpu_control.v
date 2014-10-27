module cpu_control(IR, 	Jump,	Shift_op,	Ex_top,	Shift_amounsrc,	Regdst,	ALU_op, ALU_shift_sel,	condition,	ALU_srcB,	overflow,Rd_write_byte_en,	Regdto);

input [31:0] IR; 	
input overflow; 
output reg Jump,Ex_top,Shift_amounsrc,Regdst,ALU_shift_sel,Regdto;	
output reg [1:0] 	Shift_op,ALU_srcB;
output reg [2:0]   condition;
output reg [3:0]   ALU_op,Rd_write_byte_en;

initial

begin 
{Jump,Ex_top,Shift_amounsrc,Regdst,ALU_shift_sel,Regdto}=6'b000000;	
  Shift_op=2'b00;
  ALU_srcB=2'b00;
  condition=3'b00;
  ALU_op=4'b0000;
  Rd_write_byte_en=4'b0000;
end 

always @ (*)
	begin
		case(IR[31:26])
			6'b000000:
			begin
				case(IR[5:0])
					6'b100000:            //(1):add
					begin
						ALU_op = 4'b1110;
						{Regdto,ALU_shift_sel,Regdst,Jump}=4'b0010;
						if(~overflow)
						Rd_write_byte_en=4'b1111;
						else 
						Rd_write_byte_en=4'b0000;
	               ALU_srcB=2'b00;
						condition=3'b000;
					end
					6'b100010:            //(4):sub
					begin
						ALU_op = 4'b1111;
						{Regdto,ALU_shift_sel,Regdst,Jump}=4'b0010;
						if(~overflow)
						Rd_write_byte_en=4'b1111;
						else 
						Rd_write_byte_en=4'b0000;
	               ALU_srcB=2'b00;
						condition=3'b000;
					end
					6'b100011:            //(5):subu
					begin
						ALU_op = 4'b0001;
						{Regdto,ALU_shift_sel,Regdst,Jump}=4'b0010;
						Rd_write_byte_en=4'b1111;
	               ALU_srcB=2'b00;
						condition=3'b000;
					end
					6'b000111:            //(11):srav
					begin
						ALU_op = 4'b0001;
						{Regdto,ALU_shift_sel,Regdst,Jump}=4'b0110;
						Rd_write_byte_en=4'b1111;
	               Shift_op=2'b10;
						ALU_srcB=2'b00;
						condition=3'b000;
						Shift_amounsrc=1'b1;
					end
					6'b101011:             //(13):sltu
					begin
						ALU_op = 4'b0111;
						{Regdto,ALU_shift_sel,Regdst,Jump}=4'b0010;
						Rd_write_byte_en=4'b1111;
	               ALU_srcB=2'b00;
						condition=3'b000;
					end
					6'b000010:            //(12):rotr
					begin
						ALU_op = 4'b0001;
						{Regdto,ALU_shift_sel,Regdst,Jump}=4'b0010;
						Rd_write_byte_en=4'b1111;
	               Shift_op=2'b11;
						ALU_srcB=2'b00;
						condition=3'b000;
						Shift_amounsrc=1'b0;
					end
					
				endcase
			end
			6'b001000:           //(2)addi
			begin
				ALU_op = 4'b1110;
						{Regdto,ALU_shift_sel,Regdst,Jump}=4'b1000;
						if(~overflow)
						Rd_write_byte_en=4'b1111;
						else 
						Rd_write_byte_en=4'b0000;
	               ALU_srcB=2'b01;
						condition=3'b000;
						Ex_top=1'b1;
			end
			6'b001001:           //(3)addiu
			begin
				ALU_op = 4'b0000;
				{Regdto,ALU_shift_sel,Regdst,Jump}=4'b0000;		
						Rd_write_byte_en=4'b1111;
	               ALU_srcB=2'b01;
						condition=3'b000;
						Ex_top=1'b0;
			end
			6'b001110:           //(8)xori
			begin
				ALU_op = 4'b1001;
				{Regdto,ALU_shift_sel,Regdst,Jump}=4'b1000;		
						Rd_write_byte_en=4'b1111;
	               ALU_srcB=2'b01;
						condition=3'b000;
						Ex_top=1'b0;
			end
			6'b011100:           
			begin
				case (IR[5:0])
					6'b100001:        //(9):clo
					begin
						ALU_op = 4'b0011;
				{Regdto,ALU_shift_sel,Regdst,Jump}=4'b1010;		
						Rd_write_byte_en=4'b1111;
	               ALU_srcB=2'b00;
						condition=3'b000;
						Ex_top=1'b0;
					end
					6'b100000:         //(10):clz
					begin
						ALU_op = 4'b0010;
				{Regdto,ALU_shift_sel,Regdst,Jump}=4'b1010;		
						Rd_write_byte_en=4'b1111;
	               ALU_srcB=2'b00;
						condition=3'b000;
						Ex_top=1'b0;
					end
				endcase
			end
			6'b001010:            //(14):slti
			begin
				ALU_op = 4'b0101;
				{Regdto,ALU_shift_sel,Regdst,Jump}=4'b1000;		
						Rd_write_byte_en=4'b1111;
	               ALU_srcB=2'b01;
						condition=3'b000;
						Ex_top=1'b0;
			end
			6'b000010:             //(15):j
			begin
				ALU_op = 4'b0000;
				Jump=1;
			end
			6'b000001:             //（16):bjez
	      begin 
				ALU_op=4'b0001;
				{Regdto,ALU_shift_sel,Regdst,Jump}=4'b1000;	
	         Rd_write_byte_en=4'b0000;
	         ALU_srcB=2'b00;
				condition=3'b011;
			end 
			6'b011111:             //(6):seb
	      begin 
				ALU_op=4'b1010;
				{Regdto,ALU_shift_sel,Regdst,Jump}=4'b0010;	
	         Rd_write_byte_en=4'b1111;
	         ALU_srcB=2'b00;
				condition=3'b000;
				Ex_top=1'b0;
			end 
			6'b001111:             //(7):lui
	      begin 
				ALU_op=4'b0000;
				{Regdto,ALU_shift_sel,Regdst,Jump}=4'b1000;	
	         Rd_write_byte_en=4'b1111;
	         ALU_srcB=2'b10;
				condition=3'b000;
			end 
			
			
		endcase
	end
endmodule 	 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
