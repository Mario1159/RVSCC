import rv32i_defs::*;

// N = Bit width
module ALU #(
    parameter integer N = 32
) (
    input  logic [N-1:0] a,
    input  logic [N-1:0] b,
    input  alu_opcode operation,
    output logic [N-1:0] result,
    output logic [  3:0] status
);
  logic n, z, c, v;
  always_comb begin
    case (operation)
      SUM: begin  // Addition
        {c, result} = a + b;
        v = (result[N-1] & !a[N-1] & !b[N-1]) | (!result[N-1] & a[N-1] & b[N-1]);
      end
      SUB: begin  // Substraction
        {c, result} = a - b;
        v = (result[N-1] & !a[N-1] & !b[N-1]) | (!result[N-1] & a[N-1] & b[N-1]);
      end
      OR: begin  // Or
        result = a | b;
        c = 'b0;
        v = 'b0;
      end
      AND: begin  // And
        result = a & b;
        c = 'b0;
        v = 'b0;
      end
      SLT: begin  // Set less than
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
