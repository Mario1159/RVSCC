import rv32i_defs::alu_opcode;

module Test_ALU ();
  logic [31:0] a, b;
  alu_opcode operation;
  logic [31:0] result;
  logic [ 3:0] status;
  ALU alu (
      .a(a),
      .b(b),
      .operation(operation),
      .result(result),
      .status(status)
  );

  localparam RandomSumIterations = 32;

  task operation_test(input logic[31:0] a_value, input logic[31:0] b_value, input alu_opcode operation, input logic[31:0] expected_result, input logic[3:0] expected_status);
    a = a_value;
    b = b_value;
    operation = operation;
    #1;
    assert(result == expected_result) else $error("Incorrent result in operation: %0s %0d, %0d = %0d (expected %0d)", operation.name(), a, b, result, expected_result);
    assert(status == expected_status) else $error("Incorrent flags in operation: %0s %0d, %0d = %0d (n: %0b, z: %0b, c: %0b, v: %0b) (expected %4b)", operation.name(), a, b, result, status[3], status[2], status[1], status[0], expected_status);
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;

    operation_test('d0, 'd0, SUM, 'd0, 'b0100);
    operation_test('hFFFF_FFFF, 'd0, SUM, 'hFFFF_FFFF, 'b1000);

    for(int i = 0; i < RandomSumIterations; i++) begin
      a = $random;
      b = $random;
      operation = SUM;
      #1;
      assert(result == a + b) else $error("Failed in operation: %d + %d", a, b);
    end
    $finish;
  end
endmodule
