module PraticaII(SW[17:0],HEX4[0:6], HEX5[0:6], HEX6[0:6], HEX7[0:6], HEX2[0:6], HEX3[0:6], HEX1[0:6], HEX0[0:6], KEY[3:0],LEDR[17:0], LEDG[7:0]);
input[3:0] KEY;
input[17:0] SW;
output[0:6] HEX0, HEX1, HEX4, HEX5, HEX6, HEX7, HEX2, HEX3;
output[17:0] LEDR;
output[7:0] LEDG;
wire[15:0] out;

assign LEDG[0] = KEY[0];
assign LEDG[1] = KEY[3];

hex DISP0(SW[15:12],HEX3);//instrucao
hex DISP1(SW[11:8],HEX2);//registrador de saida
hex DISP2(SW[7:4],HEX1);//registrador de parametro
hex DISP3(SW[3:0],HEX0);//parametro extra


hex DISP4(out[15:12],HEX7);//out
hex DISP5(out[11:8],HEX6);//out
hex DISP6(out[7:4],HEX5);//out
hex DISP7(out[3:0],HEX4);//out


proc PROCESSADORMUITOBOMA80KILOMETROSPORHORAVSUNOCOMESCADA(SW[15:0],KEY[3],KEY[0],SW[17],LEDR[17],out[15:0]);

endmodule

module proc (Input, Reset, Clock, Run, Done, Output);
	input [15:0] Input;
	input Reset, Clock, Run;
	output reg Done;
	output reg[15:0] Output;
	
	reg[1:0] Multiclock;
	
	reg[3:0] Instruction;
	reg[3:0] addrRegisterA;
	reg[3:0] addrRegisterB;
	reg[3:0] paramC;
		
	reg[15:0] TemporaryRegister;
	
	reg[15:0] registers[15:0];
	
	reg[15:0] memory[15:0];
	
	integer i;
	
	initial 
	begin
		Instruction=0;
		addrRegisterA=0;
		addrRegisterB=0;
		paramC=0;
		TemporaryRegister=0;
		Done=1'b0;
		Multiclock=2'b00;
		
		for(i=0;i<16;i=i+1)
			registers[i]=i;
		for(i=0;i<16;i=i+1)
			memory[i]=0;
	end

	always@(posedge Clock || Done)
	begin
		if(Instruction>0)
			Multiclock=Multiclock+2'b01;
		if(Done)
			Multiclock=0;
	end
	always @(posedge Clock or negedge Reset)
	begin
		if(Reset==0)
		begin
			Instruction=0;
			addrRegisterA=0;
			addrRegisterB=0;
			paramC=0;
			TemporaryRegister=0;
			Done=0;
			
			for(i=0;i<16;i=i+1)
				registers[i]=i;
			for(i=0;i<16;i=i+1)
				memory[i]=0;
		end
		else
		begin
			case (Multiclock)
				2'b00: // DECODE
				begin
					Done=1'b0;
					Instruction=0;
					addrRegisterA=0;
					addrRegisterB=0;
					paramC=0;
					TemporaryRegister=0;
					if(Run)
					begin
						Instruction=Input[15:12];
						addrRegisterA=Input[11:8];
						addrRegisterB=Input[7:4];
						paramC=Input[3:0];
					end		
				end
				2'b01: // EXEC
					case (Instruction)
						default:begin end//STALL
						1:TemporaryRegister=registers[addrRegisterB]+paramC;//STORE
						2:TemporaryRegister=registers[addrRegisterB]+paramC;//LOAD
						3://MVNZ - https://msdn.microsoft.com/en-us/library/aa226729(v=vs.60).aspx
						begin
							if(registers[paramC]==0)
								TemporaryRegister=registers[addrRegisterA];
							else
								TemporaryRegister=registers[addrRegisterB];
						end
						4:TemporaryRegister=registers[addrRegisterB];//MV
						5:TemporaryRegister={addrRegisterB,paramC};//MVI
						6:TemporaryRegister=registers[addrRegisterB]+registers[paramC];//ADD
						7:TemporaryRegister=registers[addrRegisterB]-registers[paramC];//SUB
						8:TemporaryRegister=registers[addrRegisterB]&registers[paramC];//AND
						9:TemporaryRegister=registers[addrRegisterB]<registers[paramC];//SLT
						10:TemporaryRegister=registers[addrRegisterB]<<registers[paramC];//SLL
						11:TemporaryRegister=registers[addrRegisterB]>>registers[paramC];//SRL
						15://PRINT
						begin
							Output=registers[addrRegisterA];
							Done=1;
						end
					endcase
				2'b10: //MEMORY ACCESS
					case (Instruction)
						default:begin end//STALL
						1:memory[TemporaryRegister]=registers[addrRegisterA];//STORE
						2:TemporaryRegister=memory[TemporaryRegister];//LOAD
					endcase
				2'b11: //WRITE BACK
					begin
						case (Instruction)
							default:begin end//STALL
							2:registers[addrRegisterA]=TemporaryRegister;//LOAD
							3:registers[addrRegisterA]=TemporaryRegister;//MVNZ
							4:registers[addrRegisterA]=TemporaryRegister;//MV
							5:registers[addrRegisterA]=TemporaryRegister;//MVI
							6:registers[addrRegisterA]=TemporaryRegister;//ADD
							7:registers[addrRegisterA]=TemporaryRegister;//SUB
							8:registers[addrRegisterA]=TemporaryRegister;//AND
							9:registers[addrRegisterA]=TemporaryRegister;//SLT
							10:registers[addrRegisterA]=TemporaryRegister;//SLL
							11:registers[addrRegisterA]=TemporaryRegister;//SRL
						endcase
						if(Instruction>0)
							Done=1'b1;
					end
			endcase
		end
	end
endmodule 

module hex (i,z);
input [3:0] i;
output reg [6:0] z;
	always @*
	case (i)
		4'b0000:     
			z=~7'b1111110;
		4'b0001:    	
			z=~7'b0110000;
		4'b0010:  		
			z=~7'b1101101; 
		4'b0011: 		
			z=~7'b1111001;
		4'b0100:	
			z=~7'b0110011;
		4'b0101:		
			z=~7'b1011011;  
		4'b0110:		
			z=~7'b1011111;
		4'b0111:		
			z=~7'b1110000;
		4'b1000:
			z=~7'b1111111;
		4'b1001:    	
			z=~7'b1111011;
		4'b1010:  		
			z=~7'b1110111; 
		4'b1011: 		
			z=~7'b0011111;
		4'b1100:	
			z=~7'b1001110;
		4'b1101:		
			z=~7'b0111101;
		4'b1110:		
			z=~7'b1001111;
		4'b1111:		
			z=~7'b1000111;
	endcase
endmodule
