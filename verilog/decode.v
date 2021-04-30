module decode(clk, rst, instr, wr_data, read1data, read2data, reg_wr_in, Rt, Rs,
  write_reg_in, imm_10_ext, imm_8_ext, write_reg, i_2, jmp, mem_wr, mem_rd, wr_r7, brnch,
  mem_to_reg, reg_wr, halt, err_reg, ALU_src, imm_in);

  input clk, rst;
  input [15:0] instr;
  input [15:0] wr_data; // needs to be gotten from the write back stage
  input reg_wr_in; // gottem from the write stage
  input [2:0] write_reg_in;
  output [2:0] Rt, Rs; // actual registers numbers to give to the forwarding unit
  output [15:0] read1data, read2data; // needs to be passed to execute for ALU
  output [15:0] imm_10_ext, imm_8_ext; // needs to be passed to execute for PC
  output [2:0] write_reg;
  output [15:0] imm_in;
  output err_reg;

  // control signals
  output i_2, jmp, mem_wr, mem_rd, wr_r7, brnch, mem_to_reg, reg_wr, halt,
    ALU_src;

  wire reg_dest, zero_ext, wr_rs;

  // register file signals
  wire [2:0] write_reg;

  // immediate signals for ALU
  wire [15:0] imm_5_ext, imm_8_ext, imm_5_z_ext, imm_8_z_ext;

  // immediate signals for PC
  wire [15:0] imm_10_ext;

  // create signals from the control unit
  control_unit cntrl(.opcode(instr[15:11]), .i_2(i_2), .reg_dest(reg_dest), 
    .jmp(jmp), .mem_wr(mem_wr), .mem_rd(mem_rd), .wr_r7(wr_r7), .wr_rs(wr_rs),
    .brnch(brnch), .mem_to_reg(mem_to_reg), .ALU_src(ALU_src),.reg_wr(reg_wr),
    .zero_ext(zero_ext), .halt(halt));

  // determine the register destination
  assign write_reg = (reg_dest) ? instr[4:2] :
                     (wr_rs) ? instr[10:8] :
                     (wr_r7) ? 3'b111 :
                     instr[7:5];

  // get Rt and Rs
  assign Rs = instr[10:8];
  assign Rt = instr[7:5];

  // register file
  rf_bypass reg_file_bp(.read1data(read1data), .read2data(read2data), .err_reg(err_reg),
    .clk(clk), .rst(rst), .read1regsel(instr[10:8]), .read2regsel(instr[7:5]),
    .writeregsel(write_reg_in), .writedata(wr_data), .write(reg_wr_in));

  // immediate sign extending
  assign imm_5_ext = {{11{instr[4]}}, instr[4:0]};
  assign imm_8_ext = {{8{instr[7]}}, instr[7:0]};
  assign imm_5_z_ext = {{11{1'b0}}, instr[4:0]};
  assign imm_8_z_ext = {{8{1'b0}}, instr[7:0]};
  assign imm_10_ext = {{5{instr[10]}}, instr[10:0]};

  // immediate selection for ALU
  assign imm_in = (zero_ext) ? ((instr[15:11] == 5'b10010) ? imm_8_z_ext : imm_5_z_ext) :
                  (i_2) ? imm_8_ext :
                  imm_5_ext;

endmodule
           