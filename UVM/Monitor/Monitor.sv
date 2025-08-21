package FIFO_monitor_pkg;
import FIFO_item_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_monitor extends uvm_monitor;
`uvm_component_utils(FIFO_monitor)
virtual Interface_FIFO FIFO_monitor_vif;
FIFO_SequenceItem FIFO_seq_item;

uvm_analysis_port #(FIFO_SequenceItem) mon_ap;

function new(string name = "FIFO_Monitor",uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
mon_ap = new("mon_ap",this);
endfunction
task run_phase(uvm_phase phase);
super.run_phase(phase);
forever 
begin
FIFO_seq_item = FIFO_SequenceItem::type_id::create("FIFO_seq_item");
@(negedge FIFO_monitor_vif.CLK);

FIFO_seq_item.rst_n = FIFO_monitor_vif.rst_n;
FIFO_seq_item.wr_en =  FIFO_monitor_vif.wr_en;
FIFO_seq_item.rd_en = FIFO_monitor_vif.rd_en;
FIFO_seq_item.bus_in = FIFO_monitor_vif.bus_in;
FIFO_seq_item.empty = FIFO_monitor_vif.empty;
FIFO_seq_item.full = FIFO_monitor_vif.full;
FIFO_seq_item.bus_out = FIFO_monitor_vif.bus_out;
FIFO_seq_item.valid = FIFO_monitor_vif.valid;
mon_ap.write(FIFO_seq_item);
`uvm_info("RUN_PHASE",FIFO_seq_item.convert2string(),UVM_HIGH)
end
endtask
endclass
endpackage