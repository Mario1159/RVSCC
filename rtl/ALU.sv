`timescale 1ns / 1ps
// N = Bit width
module ALU #(
    parameter integer N = 32
) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  logic [  2:0] opcode,
    output logic [N-1:0] result,
    output logic [  3:0] status
);
  logic n, z, c, v;
  always_comb begin
    case (opcode)
      'b000: begin  // Addition
        {c, result} = a + b;
        v = (result[N-1] & !a[N-1] & !b[N-1]) | (!result[N-1] & a[N-1] & b[N-1]);
      end
      'b001: begin  // Substraction
        {c, result} = a - b;
        v = (result[N-1] & !a[N-1] & !b[N-1]) | (!result[N-1] & a[N-1] & b[N-1]);
      end
      'b011: begin  // Or
        result = a | b;
        c = 'b0;
        v = 'b0;
      end
      'b010: begin  // And
        result = a & b;
        c = 'b0;
        v = 'b0;
      end
      'b101: begin  // Set less than
        result = {31'd0, a < b};
        c = 'b0;
        v = 'b0;
      end
      default: begin
        result = 'dx;
        c = 1'bx;
        v = 1'bx;
      end
    endcase
    n = result[N-1];
    z = (result == '0);
    status = {n, z, c, v};
  end
endmodule
