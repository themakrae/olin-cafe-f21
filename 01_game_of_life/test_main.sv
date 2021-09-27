`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_main;
  parameter N = 5;
  parameter M = N + 2;

	// Inputs
  logic clk;
  logic [1:0] buttons;
  wire [1:0] leds;
  wire [2:0] rgb;
  wire [N-1:0] cols;
  wire [N-1:0] rows;

  main #(.game_divider(1), .display_divider(1), .N(N), .M(M)) UUT(
      .clk(clk), .buttons(buttons),
      .leds(leds), .rgb(rgb), .cols(cols), .rows(rows)
  );

  int cycles = 1000; // Number of cycles to run.
	
	// Run our main clock.
	always #5 clk = ~clk;

  int offset;
  logic [N-1:0] row_to_print = 0;
	initial begin
        // Collect waveforms
        $dumpfile("main.vcd");
        $dumpvars(0, UUT);
        // Initialize module inputs.
        clk = 0;
        buttons = 2'b11; //using button[0] as reset.
        // Assert reset for long enough.
        repeat(2) @(posedge clk);
        buttons = 2'b00;

        // Let the simulation run!
        for (int i = 0; i < cycles; i = i + 1) begin
          @(posedge clk);
          $display("< cycle: %02d >", i);
          for (int j = N-1; j >= 0; j = j - 1) begin
            row_to_print = UUT.cells_q >> j*N;
            $display("-%b-", row_to_print);
          end
          $display();
        end
        
        $finish;      
	end

endmodule
