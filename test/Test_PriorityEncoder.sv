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
            assert (data_out == i[2:0] + 1 || valid == 1) else $error("[One-hot] Failed at %d", i);
            #1
            data_in = data_in << 'd1;
        end
        #1
        data_in = 'b00101111;
        assert (data_out == 'd5) else $error("[Manual entry] Failed at " + 5);
        #1
        data_in = 'b10101010;
        assert (data_out == 'd7) else $error("[Manual entry] Failed at " + 7);
        $finish;
    end
endmodule
