`timescale 1ns / 1ps
// N = Bit width
module ALU #(parameter N = 32)
(
	input logic[N-1:0] a,
	input logic[N-1:0] b,
	input logic[2:0] opcode,
	output logic[N-1:0] result,
	output logic[3:0] status
);
	logic n, z, c, v;
    logic opsign_comp, v_value;
	always_comb begin
	   // Check if the signs of the operands are equal considering substraction sign simplification over the B operand
       opsign_comp = (a[N-1] == (b[N-1] ^ opcode[0]));
       // There is an overflow if the signs are equal and the result differ from the operation sign
       // The overflow flag only gets assign when the operation is either a sum or a substraction
       v_value = opsign_comp && (result != a[N-1]);
	   case(opcode)
			'b000: begin // Addition
				{c, result} = a + b;
				v = v_value;
			end
			'b001: begin // Substraction
				{c, result} = a - b;
				v = v_value;
			end
			'b011: begin // Or
				result = a | b;
				c = 'b0;
				v = 'b0;
			end
			'b010: begin // And
				result = a & b;
				c = 'b0;
				v = 'b0;
			end
			'b101: begin // Set less than
			    result = a < b;
			    c = 'b0;
				v = 'b0;
			end
			default: begin
			    result = 'dx;
				c = 'dx;
				v = 'dx;
			end
		endcase
		n = result[N-1];
		z = (result == '0);
		status = {n, z, c, v};
	end
endmodule