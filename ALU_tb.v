`timescale 1ns/100ps;
module ALU_tb();
reg [31:0]A,B;
wire [31:0]Z;
reg Sign;
wire Zero,V,N;
reg [5:0]ALUFun;
  
initial fork
  #10 Sign = 1'b1;
  #50 A = 32'd5;
  #600 A = 32'd8;
  #50 B = 32'd99;
  #900 B = {20'b1111_1111_1111_1111_1111,12'd32};
  //add?????
  #300 ALUFun = 6'b000000;
  #300 A = 32'b0111_1111_1111_1111_1111_1111_1111_1111;
  #300 B = 32'b0111_0000_0000_0000_0000_0000_0000_0000;
  //sub?????
  #400 ALUFun = 6'b000001;
  #400 A = 32'b1000_0000_0000_0000_0000_0000_0000_0001;
  #400 B = 32'b1000_0000_0000_0000_0000_0000_0000_0001;
  //??????????
  #500 ALUFun = 6'b011000;
  #600 ALUFun = 6'b011110;
  #700 ALUFun = 6'b010110;
  #800 ALUFun = 6'b010001;
  #900 ALUFun = 6'b011010;
  //??
  #1000 A = 32'b1010;//????
  #1000 ALUFun = 6'b100000;
  #1100 ALUFun = 6'b100001;
  #1200 ALUFun = 6'b100011;
  //??
  #1300 ALUFun = 6'b110011;
  #1400 ALUFun = 6'b110001;
  #1400 A = 32'b1111_1111_1111_1111_1111_1111_1111_1001;
  #1400 B = 32'b0000_0000_0000_0000_0000_0000_0000_1010;
  #1500 ALUFun = 6'b110101;
  #1600 ALUFun = 6'b111101;
  #1700 ALUFun = 6'b111001;
  #1800 ALUFun = 6'b111111;
join

ALU ALU(.A(A),.B(B),.ALUFun(ALUFun),.Sign(Sign),.Z(Z),.Zero(Zero),.V(V),.N(N));
endmodule
