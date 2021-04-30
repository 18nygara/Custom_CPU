module alu(A, B, Op, Out, Z);
   
   input [15:0] A;
   input [15:0] B;
   input [3:0] Op;
   output [15:0] Out;
   output Z;

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

   // internal signals used to store operation results
   wire [15:0] shifter_out, andn_out, xor_out, add_out, btr_out, sco_out, seq_out, slt_out, sle_out;
   wire [15:0] A_neg, A_in;
   wire [3:0] shft_cnt;
   reg [1:0] shift_op;
   wire Cout_cla;

   // calculate -A
   cla16 neg_adder(.A(~A),.B(16'h0001),.Cin(1'b0),.S(A_neg),.Cout());

   // SUB logic for B selection
   assign A_in = (Op == SUB) ? A_neg :
                 (Op == SLT) ? A_neg :
                 (Op == SLE) ? A_neg :
                 A;
   
   // computation blocks

   // shift selection logic (turning op into a 2 bit wide operation for the shifter block)
   always @(Op) begin
      shift_op = 2'b00; // default output so no unintended latches are made
      casex (Op)
         ROL:
            shift_op = 2'b00;
         SLL:
            shift_op = 2'b01;
         SLBI:
            shift_op = 2'b01;
         ROR:
            shift_op = 2'b10;
         SRL:
            shift_op = 2'b11;
      endcase
   end

   // shifter logiv determination
   assign shft_cnt = (Op == SLBI) ? 4'b1000 : B[3:0];

   // shift
   shifter shift(.In(A), .Cnt(shft_cnt), .Op(shift_op), .Out(shifter_out));
   
   // add / sub
   cla16 adder(.A(A_in),.B(B),.Cin(1'b0),.S(add_out),.Cout(Cout_cla));
   
   // xor
   assign xor_out = A^B;
   
   // andn
   assign andn_out = A&~B;

   // btr
   assign btr_out[15] = A[0];
   assign btr_out[14] = A[1];
   assign btr_out[13] = A[2];
   assign btr_out[12] = A[3];
   assign btr_out[11] = A[4];
   assign btr_out[10] = A[5];
   assign btr_out[9] = A[6];
   assign btr_out[8] = A[7];
   assign btr_out[7] = A[8];
   assign btr_out[6] = A[9];
   assign btr_out[5] = A[10];
   assign btr_out[4] = A[11];
   assign btr_out[3] = A[12];
   assign btr_out[2] = A[13];
   assign btr_out[1] = A[14];
   assign btr_out[0] = A[15];

   // SCO
   assign sco_out = (Cout_cla == 1) ? 16'h0001 : 16'b0000;

   // SEQ
   assign seq_out = (A == B) ? 16'h0001 : 16'h0000;

   // SLT - rs was the negated term, so we expect a strictly positive value
   assign slt_out =  (A[15] == 1'b1 & B[15] == 1'b0) ? 16'h0001 : // overflow special cases
                     (A[15] == 1'b0 & B[15] == 1'b1) ? 16'h0000 :
                     (add_out[15] == 0 & add_out != 16'h0000) ? 16'h0001 : 16'h0000; // rs < rt

   // SLE
   assign sle_out = (A[15] == 1'b1 & B[15] == 1'b0) ? 16'h0001 : // overflow special cases
                    (A[15] == 1'b0 & B[15] == 1'b1) ? 16'h0000 :
                    (add_out[15] == 0) ? 16'h0001 : // rs < rt
                    (add_out == 0) ? 16'h0001 : // equal
                    16'h0000;

   // selection
   assign Out = (Op == ADD) ? add_out :
                (Op == SUB) ? add_out :
                (Op == XOR) ? xor_out :
                (Op == ANDN) ? andn_out :
                (Op == ROL) ? shifter_out :
                (Op == SLL) ? shifter_out :
                (Op == ROR) ? shifter_out :
                (Op == SRL) ? shifter_out :
                (Op == BTR) ? btr_out :
                (Op == LBI) ? B :
                (Op == SLBI) ? shifter_out | B :
                (Op == SCO) ? sco_out :
                (Op == SEQ) ? seq_out :
                (Op == SLT) ? slt_out :
                sle_out;

   // zero, greater than / equal zero, less than zero calculation
   assign Z = (Out == 0) ? 1'b1 : 1'b0;
   assign gteZ = (Out[15] == 1) ? 1'b0 : 1'b1;
   assign ltZ = (Out[15] == 1) ? 1'b1 : 1'b0;

endmodule
