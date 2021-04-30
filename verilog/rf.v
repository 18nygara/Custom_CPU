module rf (
           // Outputs
           read1data, read2data, err_reg,
           // Inputs
           clk, rst, read1regsel, read2regsel, writeregsel, writedata, write
           );
   input clk, rst;
   input [2:0] read1regsel;
   input [2:0] read2regsel;
   input [2:0] writeregsel;
   input [15:0] writedata;
   input        write;

   output [15:0] read1data;
   output [15:0] read2data;
   output        err_reg;

   // your code
   // reading logic
   wire [7:0] read_1;
   wire [7:0] read_2;
   assign read_1[0] = (~read1regsel[2] & ~read1regsel[1] & ~read1regsel[0]);
   assign read_2[0] = (~read2regsel[2] & ~read2regsel[1] & ~read2regsel[0]);

   assign read_1[1] = (~read1regsel[2] & ~read1regsel[1] & read1regsel[0]);
   assign read_2[1] = (~read2regsel[2] & ~read2regsel[1] & read2regsel[0]);

   assign read_1[2] = (~read1regsel[2] & read1regsel[1] & ~read1regsel[0]);
   assign read_2[2] = (~read2regsel[2] & read2regsel[1] & ~read2regsel[0]);

   assign read_1[3] = (~read1regsel[2] & read1regsel[1] & read1regsel[0]);
   assign read_2[3] = (~read2regsel[2] & read2regsel[1] & read2regsel[0]);

   assign read_1[4] = (read1regsel[2] & ~read1regsel[1] & ~read1regsel[0]);
   assign read_2[4] = (read2regsel[2] & ~read2regsel[1] & ~read2regsel[0]);

   assign read_1[5] = (read1regsel[2] & ~read1regsel[1] & read1regsel[0]);
   assign read_2[5] = (read2regsel[2] & ~read2regsel[1] & read2regsel[0]);

   assign read_1[6] = (read1regsel[2] & read1regsel[1] & ~read1regsel[0]);
   assign read_2[6] = (read2regsel[2] & read2regsel[1] & ~read2regsel[0]);

   assign read_1[7] = (read1regsel[2] & read1regsel[1] & read1regsel[0]);
   assign read_2[7] = (read2regsel[2] & read2regsel[1] & read2regsel[0]);
   
   // writing logic
   wire [7:0] enable_write;
   assign enable_write[0] = (~writeregsel[2] & ~writeregsel[1] & ~writeregsel[0]) & write;
   assign enable_write[1] = (~writeregsel[2] & ~writeregsel[1] & writeregsel[0]) & write;
   assign enable_write[2] = (~writeregsel[2] & writeregsel[1] & ~writeregsel[0]) & write;
   assign enable_write[3] = (~writeregsel[2] & writeregsel[1] & writeregsel[0]) & write;
   assign enable_write[4] = (writeregsel[2] & ~writeregsel[1] & ~writeregsel[0]) & write;
   assign enable_write[5] = (writeregsel[2] & ~writeregsel[1] & writeregsel[0]) & write;
   assign enable_write[6] = (writeregsel[2] & writeregsel[1] & ~writeregsel[0]) & write;
   assign enable_write[7] = (writeregsel[2] & writeregsel[1] & writeregsel[0]) & write;
   
   // module instantiation
   wire [15:0] q_out [7:0];
   register reg0(.q(q_out[0]), .d(writedata), .en(enable_write[0]), .clk(clk), .rst(rst));
   register reg1(.q(q_out[1]), .d(writedata), .en(enable_write[1]), .clk(clk), .rst(rst));
   register reg2(.q(q_out[2]), .d(writedata), .en(enable_write[2]), .clk(clk), .rst(rst));
   register reg3(.q(q_out[3]), .d(writedata), .en(enable_write[3]), .clk(clk), .rst(rst));
   register reg4(.q(q_out[4]), .d(writedata), .en(enable_write[4]), .clk(clk), .rst(rst));
   register reg5(.q(q_out[5]), .d(writedata), .en(enable_write[5]), .clk(clk), .rst(rst));
   register reg6(.q(q_out[6]), .d(writedata), .en(enable_write[6]), .clk(clk), .rst(rst));
   register reg7(.q(q_out[7]), .d(writedata), .en(enable_write[7]), .clk(clk), .rst(rst));

   // output selection logic
   assign read1data = ({16{read_1[0]}} & q_out[0]) | ({16{read_1[1]}} & q_out[1]) | 
   ({16{read_1[2]}} & q_out[2]) | ({16{read_1[3]}} & q_out[3]) | ({16{read_1[4]}} & q_out[4]) | 
   ({16{read_1[5]}} & q_out[5]) | ({16{read_1[6]}} & q_out[6]) | ({16{read_1[7]}} & q_out[7]);

   assign read2data = ({16{read_2[0]}} & q_out[0]) | ({16{read_2[1]}} & q_out[1]) | 
   ({16{read_2[2]}} & q_out[2]) | ({16{read_2[3]}} & q_out[3]) | ({16{read_2[4]}} & q_out[4]) | 
   ({16{read_2[5]}} & q_out[5]) | ({16{read_2[6]}} & q_out[6]) | ({16{read_2[7]}} & q_out[7]);

   // err logic - JUST FOR SIMULATION PURPOSES - THIS CANNOT SYNTHESIZE
   // if any of these signals have an X in them, we should output that this is an error.
   //assign err = (^read1regsel === 1'bX) | (^read2regsel === 1'bX) | (^writeregsel === 1'bX) |
   //     (write === 1'bX);

   // for actual synthesis
   assign err_reg = 1'b0;

endmodule
// DUMMY LINE FOR REV CONTROL :1:
