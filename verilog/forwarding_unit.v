module forwarding_unit(de_Rs, de_Rt, em_write_reg, mw_write_reg, em_reg_wr, mw_reg_wr,
  frwrd_sel_A, frwrd_sel_B);
  
  input em_reg_wr, mw_reg_wr; // forward the ALU out if we are writing to a reg
  input [2:0] de_Rs, de_Rt; // potential inputs to the ALU
  input [2:0] em_write_reg, mw_write_reg; // destination registers for comparison
  output [1:0] frwrd_sel_A, frwrd_sel_B; // these selects will control muxes in the ex stage

  assign frwrd_sel_A = (de_Rs == em_write_reg & em_reg_wr) ? 2'b01 : // e/m to d/e forwarding
                       (de_Rs == mw_write_reg & mw_reg_wr) ? 2'b10 : // m/w to d/e forwarding
                       2'b00; // no forwarding

  assign frwrd_sel_B = (de_Rt == em_write_reg & em_reg_wr) ? 2'b01 : // e/m to d/e forwarding
                       (de_Rt == mw_write_reg & mw_reg_wr) ? 2'b10 : // m/w to d/e forwarding
                       2'b00; // no forwarding         

endmodule