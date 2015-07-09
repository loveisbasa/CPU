module ALU(
	input [31:0]A,
	input [31:0]B,
	input [5:0]ALUFun,
	input Sign,
	output reg [31:0]Z,
	output reg Zero,V,N);

wire [31:0]Z_00;
wire [31:0]Z_01;
wire [31:0]Z_10;
wire [31:0]Z_11;
wire Zero_temp,V_temp,N_temp;

ALU_F00 ALU_F00(A,B,Sign,ALUFun[3:0],Z_00,Zero_temp,N_temp,V_temp);
ALU_F01 ALU_F01(A,B,ALUFun[3:0],Z_01);
ALU_F10 ALU_F10(A,B,ALUFun[1:0],Z_10);
ALU_F11 ALU_F11(A,B,Sign,ALUFun[3:0],Z_11);

always @(*)
begin
	case (ALUFun[5:4])
	2'b0:begin Z = Z_00;Zero = Zero_temp;V = V_temp;N = N_temp;end
	2'b01:Z = Z_01;
	2'b10:Z = Z_10;
	2'b11:Z = Z_11;
	endcase
	if (Z == 32'b0) Zero = 1'b1;
end
endmodule

//Funct == 00,generate Z
module ALU_F00(
	input [31:0]A,
	input [31:0]B,
	input Sign,
	input [3:0]Funct,
	output reg [31:0]Z,
	output reg Zero,N,V);

wire [31:0]SUB;
reg [31:0]ADD;
reg [1:0]jinwei;
wire Zero_temp,N_temp,V_temp;

ALU_SUB ALU_SUB(A,B,Sign,SUB,Zero_temp,N_temp,V_temp);

always @(*)
begin
  ADD = A + B;
	if (Funct == 4'b0001) begin Z = SUB;Zero = Zero_temp;N = N_temp;V = V_temp;end//负数溢出由SUB完成判断
	else
	begin
		Z = ADD;
		jinwei = A[31] + B[31];
		if (Sign)
		begin
			if (A[31] == B[31] && ADD[31] != A[31]) begin V = 1'b1;N = A[31];end //参考课件符号相同的两数相加，结果与加数相反发生溢出
			else begin V = 1'b0;N = ADD[31];end
		end
		else
		begin
		N = 1'b0;
			if (jinwei == 2'b10 || (jinwei == 2'b01 && ADD[31] == 1'b0)) V = 1'b1; else V = 1'b0;
		end
	end
end	
endmodule

module ALU_SUB(
	input [31:0]A,
	input [31:0]B,
	input Sign,
	output reg [31:0]SUB,
	output reg Z,N,V);//zero,negetive,yichu

reg [31:0]B_new;//产生补码

reg [1:0]jinwei;//标记进位

always @(*)
begin
  B_new = ~B+1'b1;
  assign SUB = A+B_new;//不考虑溢出,得到结果
  //判断溢出和符号
  if (Sign)
	 if (A[31] != B[31] && SUB[31] == B[31]) begin V = 1'b1;N = A[31];end //被减数与减数符号位不同，结果符号位与减数相同发生溢出
	 else
	 begin V = 1'b0;N = SUB[31];end//其他情况不会出现溢出，根据符号位判断即可
  else
	 begin
		 jinwei = A[31] + B[31];
		if (jinwei == 2'b10 || (jinwei == 1'b01 && SUB[31] == 0)) begin N = 1'b0;V = 1'b0;end
		else begin N = 1'b1;V = 1'b1;end
	 end
	 Z = (SUB)?0:1;
end
endmodule

//Funct == 01,logic operations
module ALU_F01(
	input [31:0]A,
	input [31:0]B,
	input [3:0]ALUFun,
	output [31:0]Z);

assign Z = (ALUFun==4'b1000)?A&B:
			(ALUFun==4'b1110)?A|B:
			(ALUFun==4'b0110)?A^B:
			(ALUFun==4'b0001)?~(A|B):
			(ALUFun==4'b1010)?A:31'b0;

endmodule

//Funct == 10,shift
module ALU_F10(
	input [31:0]A,
	input [31:0]B,
	input [1:0]ALUFun,
	output reg [31:0]Z);
reg [31:0]Z_temp_1,Z_temp_2,Z_temp_3,Z_temp_4,Z_temp_5;
always @(*)
begin
  case (ALUFun)
	2'b00://逻辑左移
		begin
			Z_temp_5 = (A[4])?{B[15:0],16'b0}:B;
			Z_temp_4 = (A[3])?{Z_temp_5[23:0],8'b0}:Z_temp_5;
			Z_temp_3 = (A[2])?{Z_temp_4[27:0],4'b0}:Z_temp_4;
			Z_temp_2 = (A[1])?{Z_temp_3[29:0],2'b0}:Z_temp_3;
			Z = (A[0])?{Z_temp_2[30:0],1'b0}:Z_temp_2;
		end
	2'b01://逻辑右移
		begin
			Z_temp_5 = (A[4])?{16'b0,B[31:16]}:B;
			Z_temp_4 = (A[3])?{8'b0,Z_temp_5[31:8]}:Z_temp_5;
			Z_temp_3 = (A[2])?{4'b0,Z_temp_4[31:4]}:Z_temp_4;
			Z_temp_2 = (A[1])?{2'b0,Z_temp_3[31:2]}:Z_temp_3;
			Z = (A[0])?{1'b0,Z_temp_2[31:1]}:Z_temp_2;
		end
	2'b11://算术右移
		if (B[31])
		begin
			Z_temp_5 = (A[4])?{16'b1111_1111_1111_1111,B[31:16]}:B;
			Z_temp_4 = (A[3])?{8'b1111_1111,Z_temp_5[31:8]}:Z_temp_5;
			Z_temp_3 = (A[2])?{4'b1111,Z_temp_4[31:4]}:Z_temp_4;
			Z_temp_2 = (A[1])?{2'b11,Z_temp_3[31:2]}:Z_temp_3;
			Z = (A[0])?{1'b1,Z_temp_2[31:1]}:Z_temp_2;
		end
		else
		begin
			Z_temp_5 = (A[4])?{16'b0,B[31:16]}:B;
			Z_temp_4 = (A[3])?{8'b0,Z_temp_5[31:8]}:Z_temp_5;
			Z_temp_3 = (A[2])?{4'b0,Z_temp_4[31:4]}:Z_temp_4;
			Z_temp_2 = (A[1])?{2'b0,Z_temp_3[31:2]}:Z_temp_3;
			Z = (A[0])?{1'b0,Z_temp_2[31:1]}:Z_temp_2;
		end
	endcase
end
endmodule

//Funct == 11,COP
module ALU_F11(
	input [31:0]A,
	input [31:0]B,
	input Sign,
	input [3:0]ALUFun,
	output reg[31:0]Z);
	
wire [31:0]Sub;
wire Zero,V,N;
ALU_SUB ALU_SUB(A,B,Sign,Sub,Zero,V,N);

always @(*)
begin
	case (ALUFun[3:0])
		4'b0011:Z = (Zero)?1:0;//EQ
		4'b0001:Z = (Zero)?0:1;//NEQ
		4'b0101:Z = (N)?1:0;//LT
		4'b1101:Z = (Sign && A[31])?1:0;//Signed and the first number = 1;
		4'b1001:Z = (Sign && A[31])?0:1;
		4'b1111:Z = ((Sign && A[31]) || A == 32'b0)?0:1;
	endcase
end
endmodule
