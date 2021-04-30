module memory(clk, rst, ALU_out, rd_data2, rd_mem_data, halt, mem_wr, mem_rd);

  input clk, rst;
  input halt, mem_wr, mem_rd;
  input [15:0] ALU_out, rd_data2;
  output [15:0] rd_mem_data;

  memory2c data_mem(.data_out(rd_mem_data), .data_in(rd_data2), .addr(ALU_out),
    .enable(mem_wr|mem_rd), .wr(mem_wr), .createdump(halt), .clk(clk),
    .rst(rst));

endmodule