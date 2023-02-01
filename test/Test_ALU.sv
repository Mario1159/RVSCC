`timescale 1ns / 1ps

module Test_ALU ();
  logic [31:0] a, b;
  logic [ 2:0] opcode;
  logic [31:0] result;
  logic [ 3:0] status;
  ALU alu (
      .a(a),
      .b(b),
      .opcode(opcode),
      .result(result),
      .status(status)
  );

  initial begin
    a = 'd3;
    b = 'd11;
    opcode = 'd0;
    assert(result != 'd14) $display("3 + 11 != 14");
    assert(status != 'b0000) $display("status(3 + 11) != 0000");
    $display("Test successful");
    $finish;
  end
endmodule
