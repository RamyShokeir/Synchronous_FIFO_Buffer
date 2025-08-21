package FIFO_config_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_config_obj extends uvm_object;
`uvm_object_utils(FIFO_config_obj)

virtual Interface_FIFO FIFO_vif;

function new(string name ="FIFO_config");
super.new(name);
endfunction
endclass
endpackage