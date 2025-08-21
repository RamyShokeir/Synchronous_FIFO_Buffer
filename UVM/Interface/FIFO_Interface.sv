import shared_pkg::*;
interface Interface_FIFO (CLK);
input bit CLK;
logic rst_n;
logic [BUS_WIDTH-1:0] bus_in;
logic wr_en;
logic rd_en;
logic [BUS_WIDTH-1:0] bus_out;
logic valid;
logic empty;
logic full;

modport DUT (
input CLK,
input rst_n,
input bus_in ,
input wr_en,
input rd_en,
output bus_out,
output valid,
output empty,
output full
);

endinterface