module aluop(instr, ALUOp, op);
   
   input [4:0] instr;
   input [1:0] ALUOp;
   output reg [3:0] op;

   // ALU OPERATION DEFINITIONS
   parameter ADD = 4'b0000;
   parameter SUB = 4'b0001;
   parameter XOR = 4'b0010;
   parameter ANDN = 4'b0011;
   parameter ROL = 4'b0100;
   parameter SLL = 4'b0101;
   parameter ROR = 4'b0110;
   parameter SRL = 4'b0111;
   parameter BTR = 4'b1000;
   parameter EQZ = 4'b1001;
   parameter SCO = 4'b1010;
   parameter LBI = 4'b1011;
   parameter SEQ = 4'b1100;
   parameter SLBI = 4'b1101;
   parameter SLT = 4'b1110;
   parameter SLE = 4'b1111;

   always @* begin
      op = 4'b0000; // RESET OUTPUT SO NO LATCHES ARE MADE
      case (instr)
         5'b01000: op = ADD;
         5'b01001: op = SUB;
         5'b01010: op = XOR;
         5'b01011: op = ANDN;
         5'b10100: op = ROL;
         5'b10101: op = SLL;
         5'b10110: op = ROR;
         5'b10111: op = SRL;
         5'b10000: op = ADD;
         5'b10001: op = ADD;
         5'b10011: op = ADD;
         5'b11001: op = BTR;
         5'b11100: op = SEQ;
         5'b11101: op = SLT;
         5'b11110: op = SLE;
         5'b11111: op = SCO;
         5'b01100: op = EQZ;
         5'b01101: op = EQZ;
         5'b11000: op = LBI;
         5'b00111: op = ADD;
         5'b00101: op = ADD;
         5'b11011: begin
            op = (ALUOp == 2'b00) ? ADD :
                  (ALUOp == 2'b01) ? SUB :
                  (ALUOp == 2'b10) ? XOR :
                  ANDN; // ALUOp == 11
         end
         5'b11010: begin
            op = (ALUOp == 2'b00) ? ROL :
                  (ALUOp == 2'b01) ? SLL :
                  (ALUOp == 2'b10) ? ROR :
                  SRL; // ALUOp == 11 
         end
         default:
            op = SLBI;
      endcase
   end

endmodule
