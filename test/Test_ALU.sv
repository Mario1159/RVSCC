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

  localparam RandomSumIterations = 32;

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    a = 'd0;
    b = 'd0;
    opcode = 'd0;
    #1
    assert(result == 'd0) else $error("Incorrent result in operation: %d + %d", a, b);
    assert(status == 'b0100) else $error("Incorrent flags in operation: %d + %d", a, b);

    a = 'hFFFF_FFFF;
    b = 'd0;
    #1
    assert(result == 'hFFFF_FFFF) else $error("Incorrent result in operation: %d + %d", a, b);
    assert(status == 'b1000) else $error("Incorrent flags in operation: %d + %d", a, b);

    for(int i = 0; i < RandomSumIterations; i++) begin
      a = $random;
      b = $random;
      opcode = 'd0;
      #1
      assert(result == a + b) else $error("Failed in operation: %d + %d", a, b);
    end
    $finish;
  end
endmodule
