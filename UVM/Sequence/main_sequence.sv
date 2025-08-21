package FIFO_main_sequence_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
import shared_pkg::*;
import FIFO_item_pkg::*;
class FIFO_main_sequence extends uvm_sequence #(FIFO_SequenceItem);
`uvm_object_utils(FIFO_main_sequence)

FIFO_SequenceItem main_seq_item;

function new(string name = "FIFO_main_Sequence");
super.new(name);
endfunction

task body;
repeat(10000)
begin
main_seq_item = FIFO_SequenceItem::type_id::create("seq_item");
start_item(main_seq_item);
assert(main_seq_item.randomize());
finish_item(main_seq_item);
end
endtask
endclass
endpackage