`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_led_array_driver;

  parameter N = 5;

  logic ena;
  logic [N*N-1:0] cells;

  logic [$clog2(N):0] x;
  
  wire [N-1:0] rows;
  wire [N-1:0] cols;

  led_array_driver #(.ROWS(N), .COLS(N), .N(N))
  UUT(
    .ena(ena), .cells(cells), .x(x), .rows(rows), .cols(cols)
  );

  /*
    Initial blocks are one of the few things in Verilog that actually
    executes sequentially like normal code, and runs at the top of a 
    simulation. This can sometimes work in synthesis... but it's much
    better practice to use proper synchronous reset logic instead!
  */
  initial begin
    // Collect all internal variables for waveforms.
    $dumpfile("led_array_driver.vcd");
    $dumpvars(0, UUT);

    // Initialize modules input.
    ena = 0;
    cells = -1; // -1 in two's complement is N'b111...111! So it's a great way to set all the bits of a bus to 1.
    x = 0;

    // One form of testbench (great for combinational logic) is to change inputs, put a brief delay to let the simulator update logic, then check the output values and make sure that they make sense.
    #1;
    if ((rows !== 0) || (cols !== 0)) begin
      $error("When ena is 0 rows and cols should be all zero, are %b and %b.", rows, cols);
    end
    ena = 1;

    $display("Testing an %2dx%2d LED array driver.", N, N);
    $display("(i, j), x | cells | rows | cols ");
    for (int i = 0; i < N; i = i + 1) begin
      for (int j = 0; j < N; j = j + 1) begin
        for (x = 0; x < N; x = x + 1) begin
          cells = 0;
          cells[N*j + i] = 1'b1;
          #1 $display("(%2d, %2d), %2d | 0x%h | %b | %b", i, j, x, cells, rows, cols);
          end
        end
      end
    $finish; // End the simulation.
	end

endmodule
