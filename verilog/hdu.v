module hdu(de_write_reg, de_mem_rd, em_mem_rd,
  Rt, Rs, reg_wr, brnch, jmp, NOP, NOP_mem, PC_next, PC_out, PC, de_jmp,
  de_brnch, em_brnch, em_jmp, PC_inc, halt);

  input [15:0] PC, PC_out, PC_inc;
  input [2:0] Rt, Rs;
  // write registers for comparison
  input [2:0] de_write_reg;
  // only stall on reads and jumps
  input reg_wr, de_mem_rd, em_mem_rd, jmp, brnch, de_jmp, de_brnch;
  input em_brnch, em_jmp;
  input halt;
  output NOP, NOP_mem; // stalls the f/d and d/e stage, respectively
  output [15:0] PC_next;

  assign NOP = (halt|brnch|jmp|de_jmp|de_brnch|em_brnch|em_jmp) ? 1'b1 : // stall on branches
               1'b0;

  assign NOP_mem = (de_write_reg == Rt & de_mem_rd) ? 1'b1 :
                   (de_write_reg == Rs & de_mem_rd) ? 1'b1 :
                   1'b0;

  assign PC_next = (em_brnch | em_jmp) ? PC_out : // if we jumped, move the PC
                   (NOP|NOP_mem) ? PC : // if hazard, hold the PC
                   PC_inc; 

endmodule