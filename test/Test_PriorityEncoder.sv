`timescale 1ns / 1ps

module Test_PriorityEncoder();
    logic[7:0] data_in;
    logic[2:0] data_out;
    logic valid;
    PriorityEncoder#(.N(3)) encoder(
      .data_in(data_in),
      .data_out(data_out),
      .valid(valid)
    );
    initial begin
        data_in = 'b00000001;
        for (int i = 0; i < 8; i++) begin
            #1 assert (data_out == i[2:0] && valid == 1) else $error("Failed one-hot to index check at iteration %0d, %d", i, data_out);
            data_in = data_in << 'd1;
        end
        data_in = 'b00101111;
        #1 assert (data_out == 'd5) else $error("Incorrect result with input %b", data_in);
        data_in = 'b10101010;
        #1 assert (data_out == 'd7) else $error("Incorrect result with input %b", data_in);
        $finish;
    end
endmodule
