package FIFO_driver_pkg;
import FIFO_item_pkg::*;
import FIFO_config_pkg::*;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_driver extends uvm_driver #(FIFO_SequenceItem);
`uvm_component_utils(FIFO_driver)
virtual Interface_FIFO FIFO_vif;
FIFO_SequenceItem stim_seq_item;
FIFO_config_obj FIFO_cfg;

function new(string name = "FIFO_driver", uvm_component parent = null); 
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(virtual Interface_FIFO)::get(this,"","FIFO_IF_comps",FIFO_vif))
    `uvm_fatal("Build_phase","Failed to get ALU_IF configuration")

if (!uvm_config_db #(FIFO_config_obj)::get(this, "", "CFG", FIFO_cfg))
    `uvm_fatal("DRIVER/CONFIG_NOT_SET", "Configuration object not set correctly in FIFO_driver.")
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
FIFO_vif = FIFO_cfg.FIFO_vif;
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
$display("Reached Successfully!!");
forever
begin
stim_seq_item = FIFO_SequenceItem::type_id::create("stim_seq_item");
seq_item_port.get_next_item(stim_seq_item);

FIFO_vif.rst_n = stim_seq_item.rst_n;
FIFO_vif.bus_in = stim_seq_item.bus_in;
FIFO_vif.rd_en = stim_seq_item.rd_en;
FIFO_vif.wr_en = stim_seq_item.wr_en;

@(negedge FIFO_vif.CLK);
seq_item_port.item_done();
`uvm_info("Run_Phase",stim_seq_item.convert2string_stimulus(),UVM_HIGH)
end
endtask

endclass
endpackage