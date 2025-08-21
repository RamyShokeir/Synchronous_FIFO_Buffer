package FIFO_Sequencer_pkg;
import FIFO_item_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_Sequencer extends uvm_sequencer #(FIFO_SequenceItem);
`uvm_component_utils(FIFO_Sequencer);

function new(string name ="FIFO_Sequencer",uvm_component parent = null);
super.new(name,parent);
endfunction

endclass
endpackage