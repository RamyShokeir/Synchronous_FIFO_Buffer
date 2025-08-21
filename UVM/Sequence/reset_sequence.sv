package FIFO_reset_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shared_pkg::*;
import FIFO_item_pkg::*;
class FIFO_reset_sequence extends uvm_sequence #(FIFO_SequenceItem);
`uvm_object_utils(FIFO_reset_sequence)

FIFO_SequenceItem seq_item;

function new(string name = "FIFO_reset_Sequence");
super.new(name);
endfunction

task body;
seq_item = FIFO_SequenceItem::type_id::create("seq_item");

start_item(seq_item);

seq_item.wr_en = 0;
seq_item.rd_en = 0;
seq_item.bus_in = 0;
seq_item.rst_n = 0;

finish_item(seq_item);

endtask
endclass
endpackage