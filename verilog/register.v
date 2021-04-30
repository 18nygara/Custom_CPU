module register(q, d, en, clk, rst);

// Author: Adam Nygard

  output[15:0] q;
  input[15:0] d;
  input en;
  input clk;
  input rst;

  wire [15:0] d_in;

  assign d_in = ({16{en}} & d[15:0]) | ({16{~en}} & q[15:0]);

  dff register_instance[15:0](.q(q), .d(d_in), .clk({16{clk}}), .rst({16{rst}}));

endmodule