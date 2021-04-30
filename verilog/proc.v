/* $Author: karu $ */
/* $LastChangedDate: 2009-03-04 23:09:45 -0600 (Wed, 04 Mar 2009) $ */
/* $Rev: 45 $ */
module proc (/*AUTOARG*/
   // Outputs
   err, 
   // Inputs
   clk, rst
   );

   input clk;
   input rst;

   output err;

   // None of the above lines can be modified

   // error signals
   wire err_fetch, err_reg;

   // OR all the err ouputs for every sub-module and assign it as this
   // err output
   assign err = err_fetch | err_reg;
   // As desribed in the homeworks, use the err signal to trap corner
   // cases that you think are illegal in your statemachines

   wire [15:0] instr;

   // control signals generated by the decode stage
   wire i_2, jmp, mem_wr, mem_rd, wr_r7, brnch, 
      mem_to_reg, reg_wr, halt, ALU_src;

   // PC related signals
   wire [15:0] PC_next, PC_inc, PC, PC_out;
   wire [15:0] imm_10_ext, imm_8_ext;

   // ALU related signals
   wire [15:0] ALU_out;

   // Memory signals
   wire [15:0] read2data;
   wire [15:0] rd_mem_data;

   // writeback signal
   wire [15:0] wr_data;

   // forwarding selects
   wire [1:0] frwrd_sel_A, frwrd_sel_B;

   // added wires from the pipeline
   wire [15:0] read1data, imm_in;
   wire [2:0] Rt, Rs, write_reg;

   wire [15:0] fd_instr, fd_PC_inc;

   wire [15:0] de_read1data, de_read2data, de_instr, de_PC_inc, de_imm_10_ext, de_imm_8_ext,
      de_imm_in;
   wire [2:0] de_Rs, de_Rt, de_write_reg;
   wire de_reg_wr, de_jmp, de_mem_wr, de_mem_rd, de_wr_r7, de_brnch, de_mem_to_reg, de_halt, 
      de_ALU_src;

   wire [15:0] em_PC_out, em_PC_inc, em_read2data, em_ALU_out;
   wire [2:0] em_write_reg;
   wire em_reg_wr, em_mem_wr, em_mem_rd, em_wr_r7, em_mem_to_reg, em_halt;

   wire [15:0] mw_PC_inc, mw_ALU_out, mw_rd_mem_data;
   wire [2:0] mw_write_reg;
   wire mw_reg_wr, mw_mem_wr, mw_wr_r7, mw_mem_to_reg, mw_halt;

   wire [15:0] read2data_out;

   wire NOP, NOP_mem; // NOP for rst and hazard detection
   
   fetch iFET(.clk(clk), .rst(rst), .PC_next(PC_next), .PC_inc(PC_inc), 
      .halt(mw_halt), .err_fetch(err_fetch), .instr(instr), .PC(PC));

   // F/D FF STAGE   
   dff_en FDInstrh[3:0](.q(fd_instr[15:12]), .d(instr[15:12]), .en({4{~NOP_mem}}), .clk({4{clk}}), .rst({4{rst|(NOP&~NOP_mem)}}));
   dff_pre_en FDInstrm(.q(fd_instr[11]), .d(instr[11]), .en(~NOP_mem), .clk(clk), .rst(rst|(NOP&~NOP_mem))); // preset for NOP
   dff_en FDInstrl[10:0](.q(fd_instr[10:0]), .d(instr[10:0]), .en({11{~NOP_mem}}), .clk({11{clk}}), .rst({11{rst|(NOP&~NOP_mem)}}));
   
   dff_en FDPC_inc[15:0](.q(fd_PC_inc), .d(PC_inc), .en({16{~NOP_mem}}), .clk({16{clk}}), .rst({16{rst}}));

   // decode stage is huge because of control signals
   decode iDEC(.clk(clk), .rst(rst), .instr(fd_instr), .wr_data(wr_data), .reg_wr_in(mw_reg_wr),
      .read1data(read1data), .read2data(read2data), .Rt(Rt), .Rs(Rs), .write_reg(write_reg),
      .imm_10_ext(imm_10_ext),.imm_8_ext(imm_8_ext), .i_2(i_2), .jmp(jmp), .mem_wr(mem_wr),
      .mem_rd(mem_rd), .wr_r7(wr_r7),.brnch(brnch), .write_reg_in(mw_write_reg),
      .mem_to_reg(mem_to_reg), .reg_wr(reg_wr), .halt(halt), .err_reg(err_reg),
      .ALU_src(ALU_src), .imm_in(imm_in));
   
   // D/E FF STAGE
   dff DEInstrh[3:0](.q(de_instr[15:12]), .d(fd_instr[15:12]), .clk({4{clk}}), .rst({4{rst|NOP_mem}}));
   dff_pre DEInstrm(.q(de_instr[11]), .d(fd_instr[11]), .clk(clk), .rst(rst|NOP_mem)); // preset for NOP
   dff DEInstrl[10:0](.q(de_instr[10:0]), .d(fd_instr[10:0]), .clk({11{clk}}), .rst({11{rst|NOP_mem}}));
   
   dff DEPC_inc[15:0](.q(de_PC_inc), .d(fd_PC_inc), .clk({16{clk}}), .rst({16{rst}}));
   dff DEread1data[15:0](.q(de_read1data), .d(read1data), .clk({16{clk}}), .rst({16{rst|NOP_mem}}));
   dff DEread2data[15:0](.q(de_read2data), .d(read2data), .clk({16{clk}}), .rst({16{rst|NOP_mem}}));
   dff DEimm_10_ext[15:0](.q(de_imm_10_ext), .d(imm_10_ext), .clk({16{clk}}), .rst({16{rst|NOP_mem}}));
   dff DEimm_8_ext[15:0](.q(de_imm_8_ext), .d(imm_8_ext), .clk({16{clk}}), .rst({16{rst|NOP_mem}}));
   dff DEimm_in[15:0](.q(de_imm_in), .d(imm_in), .clk({16{clk}}), .rst({16{rst|NOP_mem}}));
   dff DERs[2:0](.q(de_Rs), .d(Rs), .clk({3{clk}}), .rst({3{rst|NOP_mem}}));
   dff DERt[2:0](.q(de_Rt), .d(Rt), .clk({3{clk}}), .rst({3{rst|NOP_mem}}));
   dff DERd[2:0](.q(de_write_reg), .d(write_reg), .clk({3{clk}}), .rst({3{rst|NOP_mem}}));
   dff DEreg_wr(.q(de_reg_wr), .d(reg_wr), .clk(clk), .rst(rst|NOP_mem));
   dff DEjmp(.q(de_jmp), .d(jmp), .clk(clk), .rst(rst|NOP_mem));
   dff DEmem_wr(.q(de_mem_wr), .d(mem_wr), .clk(clk), .rst(rst|NOP_mem));
   dff DEmem_rd(.q(de_mem_rd), .d(mem_rd), .clk(clk), .rst(rst|NOP_mem));
   dff DEwr_r7(.q(de_wr_r7), .d(wr_r7), .clk(clk), .rst(rst|NOP_mem));
   dff DEbrnch(.q(de_brnch), .d(brnch), .clk(clk), .rst(rst|NOP_mem));
   dff DEmem_to_reg(.q(de_mem_to_reg), .d(mem_to_reg), .clk(clk), .rst(rst|NOP_mem));
   dff DEALU_src(.q(de_ALU_src), .d(ALU_src), .clk(clk), .rst(rst|NOP_mem));
   dff DEhalt(.q(de_halt), .d(halt), .clk(clk), .rst(rst|NOP_mem));

   execute iEX(.read1data(de_read1data), .read2data(de_read2data),
      .instr_op(de_instr[15:11]), .instr_alu_op(de_instr[1:0]), .jmp(de_jmp),
      .brnch(de_brnch), .PC_inc(de_PC_inc), .imm_10_ext(de_imm_10_ext),
      .imm_8_ext(de_imm_8_ext), .PC_out(PC_out), .ALU_out(ALU_out), .ALU_src(de_ALU_src),
      .em_ALU_out(em_ALU_out), .wr_data(wr_data), .frwrd_sel_A(frwrd_sel_A),
      .frwrd_sel_B(frwrd_sel_B), .imm_in(de_imm_in), .read2data_out(read2data_out));

   // E/M FF STAGE
   dff EMPC_inc[15:0](.q(em_PC_inc), .d(de_PC_inc), .clk({16{clk}}), .rst({16{rst}}));
   dff EMPC_out[15:0](.q(em_PC_out), .d(PC_out), .clk({16{clk}}), .rst({16{rst}}));
   dff EMread2data[15:0](.q(em_read2data), .d(read2data_out), .clk({16{clk}}), .rst({16{rst}}));
   dff EMALU_out[15:0](.q(em_ALU_out), .d(ALU_out), .clk({16{clk}}), .rst({16{rst}}));
   dff EMRd[2:0](.q(em_write_reg), .d(de_write_reg), .clk({3{clk}}), .rst({3{rst}}));
   dff EMjmp(.q(em_jmp), .d(de_jmp), .clk(clk), .rst(rst));
   dff EMbrnch(.q(em_brnch), .d(de_brnch), .clk(clk), .rst(rst));
   dff EMreg_wr(.q(em_reg_wr), .d(de_reg_wr), .clk(clk), .rst(rst));
   dff EMmem_wr(.q(em_mem_wr), .d(de_mem_wr), .clk(clk), .rst(rst));
   dff EMmem_rd(.q(em_mem_rd), .d(de_mem_rd), .clk(clk), .rst(rst));
   dff EMwr_r7(.q(em_wr_r7), .d(de_wr_r7), .clk(clk), .rst(rst));
   dff EMmem_to_reg(.q(em_mem_to_reg), .d(de_mem_to_reg), .clk(clk), .rst(rst));
   dff EMhalt(.q(em_halt), .d(de_halt), .clk(clk), .rst(rst));

   memory iMEM(.clk(clk), .rst(rst), .ALU_out(em_ALU_out), 
      .rd_data2(em_read2data), .rd_mem_data(rd_mem_data), .halt(mw_halt),
      .mem_wr(em_mem_wr), .mem_rd(em_mem_rd));

   // M/W FF STAGE
   dff MWPC_inc[15:0](.q(mw_PC_inc), .d(em_PC_inc), .clk({16{clk}}), .rst({16{rst}}));
   dff MWALU_out[15:0](.q(mw_ALU_out), .d(em_ALU_out), .clk({16{clk}}), .rst({16{rst}}));
   dff MWrd_mem_data[15:0](.q(mw_rd_mem_data), .d(rd_mem_data), .clk({16{clk}}), .rst({16{rst}}));
   dff MWRd[2:0](.q(mw_write_reg), .d(em_write_reg), .clk({3{clk}}), .rst({3{rst}}));
   dff MWreg_wr(.q(mw_reg_wr), .d(em_reg_wr), .clk(clk), .rst(rst));
   dff MWmem_wr(.q(mw_mem_wr), .d(em_mem_wr), .clk(clk), .rst(rst));
   dff MWwr_r7(.q(mw_wr_r7), .d(em_wr_r7), .clk(clk), .rst(rst));
   dff MWmem_to_reg(.q(mw_mem_to_reg), .d(em_mem_to_reg), .clk(clk), .rst(rst));
   dff MWhalt(.q(mw_halt), .d(em_halt), .clk(clk), .rst(rst));

   write iWR(.ALU_out(mw_ALU_out), .PC_inc(mw_PC_inc), .mem_to_reg(mw_mem_to_reg),
      .mem_wr(mw_mem_wr), .wr_data(wr_data), .wr_r7(mw_wr_r7), 
      .rd_mem_data(mw_rd_mem_data));

   // FORWARDING UNIT
   forwarding_unit frwrd(.de_Rs(de_Rs), .de_Rt(de_Rt), .em_write_reg(em_write_reg),
      .mw_write_reg(mw_write_reg), .em_reg_wr(em_reg_wr), .mw_reg_wr(mw_reg_wr),
      .frwrd_sel_A(frwrd_sel_A), .frwrd_sel_B(frwrd_sel_B));

   // HAZARD DETECTION UNIT
   hdu hazard_unit(.de_write_reg(de_write_reg), .de_mem_rd(de_mem_rd), .em_mem_rd(em_mem_rd),
      .Rt(Rt), .Rs(Rs), .reg_wr(reg_wr), .brnch(brnch), .jmp(jmp), .NOP(NOP),
      .PC_next(PC_next), .PC_out(em_PC_out), .PC(PC), .de_jmp(de_jmp), .NOP_mem(NOP_mem),
      .de_brnch(de_brnch), .PC_inc(PC_inc), .em_brnch(em_brnch), .em_jmp(em_jmp),
      .halt(halt));

endmodule // proc
// DUMMY LINE FOR REV CONTROL :0:
