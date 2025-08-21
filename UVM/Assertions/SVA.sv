import shared_pkg::*;
module FIFO_SVA(Interface_FIFO.DUT Interface_Handle);


logic [BUS_WIDTH-1:0] bus_in,bus_out;
assign clk = Interface_Handle.CLK;
assign rst_n = Interface_Handle.rst_n;
assign bus_in = Interface_Handle.bus_in;
assign wr_en = Interface_Handle.wr_en;
assign rd_en =  Interface_Handle.rd_en;
assign bus_out = Interface_Handle.bus_out;
assign valid = Interface_Handle.valid;
assign empty = Interface_Handle.empty;
assign full = Interface_Handle.full;

sequence reset_sequence;
  !rst_n;    // rst_n = 0 means reset active
endsequence

sequence output_reset;
  (bus_out == 0 && valid == 0 && empty == 1 && full == 0);
endsequence
sequence read_sequence;
(rd_en && !empty);
endsequence
sequence valid_sequence;
valid;
endsequence
// Properties

// Reset Checking
property reset_property;
    @(posedge clk) reset_sequence |-> output_reset;
endproperty

// Valid Checking
property read_valid_property;
  @(posedge clk) disable iff (!rst_n)
    (read_sequence) |=> (valid_sequence);
endproperty


// Assertions
assert property (reset_property);
assert property (read_valid_property);
// Cover
cover property (reset_property);
cover property (read_valid_property);

endmodule