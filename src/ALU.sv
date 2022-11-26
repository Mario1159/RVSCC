`timescale 1ns / 1ps
// N = Bit width
module ALU #(parameter N = 32)
(
	input logic[N-1:0] a,
	input logic[N-1:0] b,
	input logic[1:0] opcode,
	output logic[N-1:0] result,
	output logic[3:0] status
);
	logic n, z, c, v;
    // Check if the signs of the operands are equal considering substraction sign simplification over the B operand
    logic opsign_comp = (a[N-1] == (b[N-1] ^ opcode[0]));
    // There is an overflow if the signs are equal and the result differ from the operation sign
    // The overflow flag only gets assign when the operation is either a sum or a substraction
    logic v_value = opsign_comp && (result != a[N-1]);

	always_comb begin
	   case(opcode)
			2'd0: begin // Addition
				{c, result} = a + b;
				v = v_value;
			end
			2'd1: begin // Substraction
				{c, result} = a - b;
				v = v_value;
			end
			2'd2: begin // Or
				result = a | b;
				c = 1'b0;
				v = 1'b0;
			end
			2'd3: begin // And
				result = a & b;
				c = 1'b0;
				v = 1'b0;
			end
		endcase
		n = result[N-1];
		z = (result == '0);
		status = {n, z, c, v};
	end
endmodule