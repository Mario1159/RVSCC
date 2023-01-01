`timescale 1ns / 1ps

// 2**N to N Priority encoder
module PriorityEncoder #(
    parameter N = 4
)(
    input logic[2**N - 1:0] data_in,
    output logic[N - 1:0] data_out,
    output logic valid
);
always_comb begin
    data_out = 'dx;
    for (int i = 0; i < 2**N; i++) begin
        if (data_in[i])
            data_out = i;
    end
    if (data_in == 0)
        valid = 0;
    else 
        valid = 1;
end
endmodule
