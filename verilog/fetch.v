module fetch(clk, rst, instr, PC_next, PC_inc, halt, err_fetch, PC);

  input clk, rst;
  input halt;
  input [15:0] PC_next;
  output [15:0] instr;
  output [15:0] PC_inc;
  output err_fetch;
  output [15:0] PC;

  // add two to the PC
  cla16 PC_adder(.A(PC), .B(16'h0002), .Cin(1'b0), .S(PC_inc), .Cout());

  // register storing the PC
  register PC_reg(.q(PC), .d(PC_next), .en(1'b1), .clk(clk), .rst(rst));

  // fetch the instruction from memory using the PC address
  memory2c instr_mem(.data_out(instr), .data_in(16'h0000), .addr(PC),
    .enable(1'b1), .wr(1'b0), .createdump(halt), .clk(clk), .rst(rst));

  // for simulation purposes only - cannot synthesize
  //assign err_fetch = (^PC === 1'bX) ? 1'b1 : 1'b0;

  // for actual synthesis, use this
  assign err_fetch = 1'b0;

endmodule