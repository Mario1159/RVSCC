`include "timescale.sv"

module tt_um_mario1159_rv32core (
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // will go high when the design is enabled
  input  wire       clk,      // clock
  input  wire       rst_n     // reset_n - low to reset
);
  assign uio_oe[7:0] = 'd0;
  assign uio_out[7:0] = 'dz;

  single_cycle_datapath dut (
      .clk(clk),
      .rst(rst),
      .instr(ui_in[7:0]),
      .addr(),
      .alu_result(uo_out[7:0]),
      .read_data('d0),
      .write_enable(),
  );
  
endmodule