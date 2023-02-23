`timescale 1ns / 1ps

module Test_RegisterFile();
    logic clk, rst;
    logic[4:0] addr_1, addr_2, addr_3;
    logic write_enable_3;
    logic[31:0] write_data_3;
    
    logic[31:0] read_data_1, read_data_2;
    
    RegisterFile register_file(
        clk,
        rst,
        addr_1,
        addr_2,
        addr_3,
        write_enable_3,
        write_data_3,
        read_data_1,
        read_data_2
        );
    
    always #1 clk = ~clk;
    
    localparam N_REG_ADDR = 5;
    localparam N_DATA = 32;
    logic [N_REG_ADDR-1:0][N_DATA-1:0] write_values;
    initial begin
        $dumpfile("regfile.vcd");
        $dumpvars;
        // Reset
        clk = 0;
        rst = 1;
        write_enable_3 = 0;
        #4;
        rst = 0;
        #1;
        // Write to all registers
        write_enable_3 = 1;
        for (int i = 0; i < 2**N_REG_ADDR; i++) begin
        addr_1 = 5'($urandom_range(0, 2**5));
        addr_2 = 5'($urandom);
        addr_3 = i[4:0];
        write_values[i] = $random();
        write_data_3 = write_values[i];
        #2;
        end
        // Read and compare the values stored in each register using addr_1
        write_enable_3 = 0;
        #4;
        for (int i = 0; i < 2**N_REG_ADDR; i++) begin
        addr_1 = i[4:0];
        addr_2 = 5'($random());
        addr_3 = 5'($random());
        #2;
        if (i == 0) begin
        assert (read_data_1 == 'd0)
        else $error("Read failed at register x0 using addr_1, value should stay at 0");
        end else begin
        assert (read_data_1 == write_values[i])
        else $error("Read failed at register x%h using addr_1 %d, %d", addr_1, read_data_1, write_values[i]);
        end
        end
        // Read and compare the values stored in each register using addr_2
        write_enable_3 = 0;
        #4;
        for (int i = 0; i < 2**N_REG_ADDR; i++) begin
        addr_1 = 5'($random());
        addr_2 = i[4:0];
        addr_3 = 5'($random());
        #2;
        assert (read_data_2 == write_values[i])
        else $error("Read failed at address %h using addr_2 %d", addr_2, read_data_2);
        end
        $finish;
    end
endmodule
