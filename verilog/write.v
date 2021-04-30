module write(ALU_out, PC_inc, mem_to_reg, mem_wr, wr_data, wr_r7, rd_mem_data);

  input [15:0] ALU_out, PC_inc, rd_mem_data;
  input mem_wr, mem_to_reg, wr_r7;
  output [15:0] wr_data;

  assign wr_data = wr_r7 ? PC_inc :
                   mem_to_reg ? rd_mem_data :
                   ALU_out;

endmodule