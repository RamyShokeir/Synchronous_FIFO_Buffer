package FIFO_item_pkg;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_SequenceItem extends uvm_sequence_item;
    `uvm_object_utils(FIFO_SequenceItem)
    //Defining the Fields of the Sequence Item
// Part A
rand bit rst_n;
rand bit[BUS_WIDTH-1:0] bus_in;
rand bit wr_en;
rand bit rd_en;

logic [BUS_WIDTH-1:0] bus_out;
logic valid;
logic empty;
logic full;

constraint Block_1_RESET
{
//98% RESET is Deactivated , 2% Activated
 rst_n dist {1:=98 , 0:=2};
}
// Print each Input Stimulus
function string convert2string();
return $sformatf("%s reset = 0b%b , bus_in = 0b%b , wr_en = 0b%b , rd_en =0b%b , bus_out = 0b%b , valid =0b%b , empty =0b%b , full =0b%b",super.convert2string(),rst_n,bus_in,wr_en,rd_en,bus_out,valid,empty,full);
endfunction
function string convert2string_stimulus();
return $sformatf("%s reset = 0b%b , bus_in = 0b%b , wr_en = 0b%b , rd_en =0b%b",super.convert2string(),rst_n,bus_in,wr_en,rd_en);
endfunction
endclass
endpackage