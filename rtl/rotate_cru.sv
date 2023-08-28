`include "timescale.sv"

module rotate_cru#(
    parameter ADDR_SIZE = 32,
    parameter NUM_SETS = 16,
    parameter NUM_WAYS = 4,
    parameter BLOCK_SIZE = 32
)(
    input logic clk, rst,
    input logic replace,
    output logic[LRU_INDEX_SIZE - 1:0] preferred
);
    logic[LRU_INDEX_SIZE - 1:0] write_preference;
    
    always_comb begin
        preferred = write_preference;
    end
    
    always_ff @(posedge clk) begin
        if (rst)
            write_preference <= 0;
        else if(replace)
            write_preference += 1;
    end
        

endmodule
