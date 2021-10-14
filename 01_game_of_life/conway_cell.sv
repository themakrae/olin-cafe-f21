`default_nettype none

module conway_cell(clk, rst, ena, state_0, state_d, state_q, neighbors);
  input wire clk;
  input wire rst;
  input wire ena;

  input wire state_0;
  output logic state_d;
  output logic state_q;

  input wire [7:0] neighbors;
  logic [3:0] living_neighbors;

  // combinational logic that says if the cell lives or dies 
  // (drives the d input to the flip flop)
  always_comb begin
    if(living_neighbors > 3) state_d = 0;
    else state_d = 1'bx;
  end

  // create a flip flop with rst and enable
  always_ff @(posedge clk) begin : cell_flip_flop
    // state_q <= d_value.
    // <= "becomes"
    if(rst) begin // create a mux
      state_q <= state_0;
    end
    else if (ena) begin
      state_q <= state_d;
    end
    else begin // This is not required
      state_q <= state_q; // hold current value
    end
  end



endmodule