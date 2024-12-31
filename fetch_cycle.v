module fetch_cycle(clk, rst, PCSrcE, PCTargetE, 
InstrD, PCD, PCPlus4D);
 // Declare input & outputs
 input clk, rst;
 input PCSrcE;
 input [31:0] PCTargetE;
 output [31:0] InstrD;
 output [31:0] PCD, PCPlus4D;
 // Declaring interim wires
 wire [31:0] PC_F, PCF, PCPlus4F;
 wire [31:0] InstrF;
 // Declaration of Register
 reg [31:0] InstrF_reg;
 reg [31:0] PCF_reg, PCPlus4F_reg;
 // Initiation of Modules
 // Declare PC Mux
 Mux PC_MUX (.a(PCPlus4F),
 .b(PCTargetE),
 .s(PCSrcE),
 .c(PC_F)
 );
 // Declare PC Counter
 PC_Module Program_Counter (
 .clk(clk),
 .rst(rst),
 .PC(PCF),
 .PC_Next(PC_F)
 );
 // Declare Instruction Memory
 Instruction_Memory IMEM (
 .rst(rst),
 .A(PCF),
 .RD(InstrF)
 );
 // Declare PC adder
 PC_Adder PC_adder (
 .a(PCF),
 .b(32'h00000004),
 .c(PCPlus4F)
 );
 // Fetch Cycle Register Logic
 always @(posedge clk or negedge rst) begin
 if(rst == 1'b0) begin
 InstrF_reg <= 32'h00000000;
 PCF_reg <= 32'h00000000;
 PCPlus4F_reg <= 32'h00000000;
 end
 else begin
 InstrF_reg <= InstrF;
 PCF_reg <= PCF;
 PCPlus4F_reg <= PCPlus4F;
 end
 end
 // Assigning Registers Value to the Output port
 assign InstrD = (rst == 1'b0) ? 32'h00000000 : 
InstrF_reg;
 assign PCD = (rst == 1'b0) ? 32'h00000000 : 
PCF_reg;
 assign PCPlus4D = (rst == 1'b0) ? 32'h00000000 : 
PCPlus4F_reg;
endmodule
module hazard_unit(rst, RegWriteM, RegWriteW, 
RD_M, RD_W, Rs1_E, Rs2_E, ForwardAE, 
ForwardBE);
 // Declaration of I/Os
 input rst, RegWriteM, RegWriteW;
 input [4:0] RD_M, RD_W, Rs1_E, Rs2_E;
 output [1:0] ForwardAE, ForwardBE;
 
 assign ForwardAE = (rst == 1'b0) ? 2'b00 : 
 ((RegWriteM == 1'b1) & (RD_M != 
5'h00) & (RD_M == Rs1_E)) ? 2'b10 :
 ((RegWriteW == 1'b1) & (RD_W != 
5'h00) & (RD_W == Rs1_E)) ? 2'b01 : 2'b00;
 
 assign ForwardBE = (rst == 1'b0) ? 2'b00 : 
 ((RegWriteM == 1'b1) & (RD_M != 
5'h00) & (RD_M == Rs2_E)) ? 2'b10 :
 ((RegWriteW == 1'b1) & (RD_W != 
5'h00) & (RD_W == Rs2_E)) ? 2'b01 : 2'b00;
endmodule
