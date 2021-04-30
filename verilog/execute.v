module execute(read1data, read2data, em_ALU_out, wr_data, frwrd_sel_A,
  frwrd_sel_B, imm_in, instr_op, instr_alu_op, jmp, brnch, PC_inc, imm_10_ext,
  imm_8_ext, PC_out, ALU_out, ALU_src, read2data_out);

  input [15:0] read1data, read2data; // reads from decode stage
  input [15:0] imm_in; // immediate operand for the B input
  input [15:0] em_ALU_out, wr_data; // forwarded data
  input [1:0] frwrd_sel_A, frwrd_sel_B; // forwarding selection logic
  input [15:0] PC_inc;
  input [15:0] imm_10_ext, imm_8_ext; // used for PC calculation
  input [4:0] instr_op;
  input [1:0] instr_alu_op;
  input jmp, brnch, ALU_src;
  output [15:0] PC_out;
  output [15:0] ALU_out;
  output [15:0] read2data_out;

  wire PC_branch, beq;
  wire [3:0] ALU_op;
  wire [15:0] PC_imm_8, PC_disp;

  // definitions for branch instructions
  parameter EQZ = 5'b01100;
  parameter NEZ = 5'b01101;
  parameter LTZ = 5'b01110;
  parameter GEZ = 5'b01111;

  // selection of ALU signals
  wire [15:0] ALU_in_A, ALU_in_B;

  assign ALU_in_A = (frwrd_sel_A == 2'b00) ? read1data : // no forwarding
                    (frwrd_sel_A == 2'b01) ? em_ALU_out : // e/m to d/e forwarding
                    wr_data; // m/w to d/e forwarding
  assign read2data_out = (frwrd_sel_B == 2'b00) ? read2data : // no forwarding
                         (frwrd_sel_B == 2'b01) ? em_ALU_out : // e/m to d/e forwarding
                         wr_data; // m/w to d/e forwarding
  assign ALU_in_B = (ALU_src) ? imm_in : read2data_out; // cascade the mux so imm selection takes prescedent

  // ALU operand parsing and ALU execution
  aluop iALU_Op(.instr(instr_op), .ALUOp(instr_alu_op), .op(ALU_op));
  alu iALU(.A(ALU_in_A), .B(ALU_in_B), .Op(ALU_op), .Out(ALU_out), .Z(ALU_zero));

  // displacement addition
  cla16 PC_add_dis(.A(PC_inc), .B(imm_10_ext), .Cin(1'b0), .S(PC_disp), .Cout());

  // branch addition
  cla16 PC_add_br(.A(PC_inc), .B(imm_8_ext), .Cin(1'b0), .S(PC_imm_8), .Cout());

  // branch detection - need multiple options instead of just ALU Zero
  assign PC_branch = (instr_op == EQZ) ? ((ALU_in_A == 0) ? 1'b1 : 1'b0) :
                     (instr_op == NEZ) ? ((ALU_in_A != 0) ? 1'b1 : 1'b0) :
                     (instr_op == LTZ) ? ((ALU_in_A[15] == 1) ? 1'b1 : 1'b0) :
                     (instr_op == GEZ) ? ((ALU_in_A[15] == 0) ? 1'b1 : 1'b0) :
                     1'b0;

  assign beq = brnch & PC_branch;

  // PC determination
  assign PC_out = (instr_op == 5'b00101) ? ALU_out : // JR instr
                  (instr_op == 5'b00111) ? ALU_out : // JALR instr
                  jmp ? PC_disp :
                  beq ? PC_imm_8 :
                  PC_inc;
endmodule