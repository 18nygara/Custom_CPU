module control_unit(opcode, i_2, reg_dest, jmp, mem_wr, mem_rd, wr_r7, wr_rs, 
  brnch, mem_to_reg, ALU_src, reg_wr, zero_ext, halt);

  input [4:0] opcode;
  output reg i_2, reg_dest, jmp, mem_wr, mem_rd, wr_r7, wr_rs, brnch, 
    mem_to_reg, ALU_src, reg_wr, zero_ext, halt;

  always @(opcode) begin
    // DEFAULT OUTPUTS SO NO LATCHES ARE CREATED
    i_2 = 0;
    reg_dest = 0;
    jmp = 0;
    mem_wr = 0;
    mem_rd = 0;
    wr_r7 = 0;
    wr_rs = 0;
    brnch = 0;
    mem_to_reg = 0;
    ALU_src = 0;
    reg_wr = 0;
    zero_ext = 0;
    halt = 0;
    // CASE STATEMENT TO DECIDE WHICH CONTROL SIGNALS GO HIGH AND LOW
    casex (opcode)
      5'b01000: begin // ADDI
        reg_wr = 1'b1;
        ALU_src = 1'b1;
      end
      5'b01001: begin// SUBI
        reg_wr = 1'b1;
        ALU_src = 1'b1;
      end
      5'b01010: begin// XORI
        reg_wr = 1'b1;
        ALU_src = 1'b1;
        zero_ext = 1'b1;
      end
      5'b01011: begin// ANDNI
        reg_wr = 1'b1;
        ALU_src = 1'b1;
        zero_ext = 1'b1;
      end
      5'b10100: begin// ROLI
        reg_wr = 1'b1;
        ALU_src = 1'b1;
      end
      5'b10101: begin// SLLI
        reg_wr = 1'b1;
        ALU_src = 1'b1;
      end
      5'b10110: begin// RORI
        reg_wr = 1'b1;
        ALU_src = 1'b1;
      end
      5'b10111: begin// SRLI
        reg_wr = 1'b1;
        ALU_src = 1'b1;
      end
      5'b10000: begin// ST
        mem_wr = 1'b1;
        ALU_src = 1'b1;
      end
      5'b10001: begin// LD
        reg_wr = 1'b1;
        mem_to_reg = 1'b1;
        mem_rd = 1'b1;
        ALU_src = 1'b1;
      end
      5'b10011: begin// STU
        wr_rs = 1'b1;
        mem_wr = 1'b1;
        ALU_src = 1'b1;
        reg_wr = 1'b1; 
      end
      5'b11001: begin// BTR
        reg_wr = 1'b1;
        reg_dest = 1'b1;
      end
      5'b11011: begin// ADD, SUB, XOR ANDN
        reg_wr = 1'b1;
        reg_dest = 1'b1;
      end
      5'b11010: begin// ROL, SLL, ROR, SRL
        reg_wr = 1'b1;
        reg_dest = 1'b1;
      end
      5'b11100: begin// SEQ
        reg_wr = 1'b1;
        reg_dest = 1'b1;
      end
      5'b11101: begin// SLT
        reg_wr = 1'b1;
        reg_dest = 1'b1;
      end
      5'b11110: begin// SLE
        reg_wr = 1'b1;
        reg_dest = 1'b1;
      end
      5'b11111: begin// SCO
        reg_wr = 1'b1;
        reg_dest = 1'b1;
      end
      5'b01100: begin// BEQZ
        ALU_src = 1'b1;
        i_2 = 1'b1;
        brnch = 1'b1;      
      end
      5'b01101: begin// BNEZ
        ALU_src = 1'b1;
        i_2 = 1'b1;
        brnch = 1'b1;  
      end
      5'b01110: begin// BLTZ
        ALU_src = 1'b1;
        i_2 = 1'b1;
        brnch = 1'b1;  
      end
      5'b01111: begin// BGEZ
        ALU_src = 1'b1;
        i_2 = 1'b1;
        brnch = 1'b1;  
      end
      5'b11000: begin// LBI
        wr_rs = 1'b1;
        i_2 = 1'b1;
        reg_wr = 1'b1;
        ALU_src = 1'b1;
      end
      5'b10010: begin// SLBI
        wr_rs = 1'b1;
        ALU_src = 1'b1;
        i_2 = 1'b1;
        zero_ext = 1'b1;
        reg_wr = 1'b1;
      end
      5'b00100: // JDIS
        jmp = 1'b1;
      5'b00101: begin// JR
        ALU_src = 1'b1;
        i_2 = 1'b1;
        brnch = 1'b1;
      end
      5'b00110: begin// JAL
        wr_r7 = 1'b1;
        jmp = 1'b1;
        reg_wr = 1'b1;
      end
      5'b00111: begin// JALR
        wr_r7 = 1'b1;
        reg_wr = 1'b1;
        jmp = 1'b1;
        ALU_src = 1'b1;
        i_2 = 1'b1;
      end
      5'b00000: // HALT
        halt = 1'b1;
      default: begin// NOP
        // hold all signals at 0 - from above assignment
      end
    endcase
  end
endmodule