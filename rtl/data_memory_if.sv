interface data_memory_if #(
    parameter int ADDR_SIZE = 32,
    parameter int DATA_SIZE = 32
) (
    input logic clk,
    input logic rst
);
  logic [ADDR_SIZE-1:0] addr;
  logic write_enable;
  logic [DATA_SIZE-1:0] write_data;
  logic [DATA_SIZE-1:0] read_data;
  logic valid;
  logic ready;

  modport datapath(input read_data, output addr, write_enable, write_data);
  modport ram(input clk, rst, addr, write_enable, write_data, output read_data);
endinterface

