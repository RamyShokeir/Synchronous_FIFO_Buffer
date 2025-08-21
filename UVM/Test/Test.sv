package FIFO_test_pkg;
import shared_pkg::*;
import FIFO_reset_sequence_pkg::*;
import FIFO_main_sequence_pkg::*;
import FIFO_env_pkg::*;
import FIFO_config_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
class FIFO_test extends uvm_test;
`uvm_component_utils(FIFO_test)
FIFO_env env;
virtual Interface_FIFO FIFO_vif;
FIFO_config_obj FIFO_cfg;

FIFO_main_sequence main_seq;
FIFO_reset_sequence reset_seq;

function new(string name = "FIFO_test",uvm_component parent = null);
super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
env = FIFO_env::type_id::create("env",this);
FIFO_cfg = FIFO_config_obj::type_id::create("FIFO_cfg");
main_seq = FIFO_main_sequence::type_id::create("main_seq",this);
reset_seq = FIFO_reset_sequence::type_id::create("reset_seq",this);

if(!uvm_config_db #(virtual Interface_FIFO)::get(this,"","FIFO_IF",FIFO_vif))
   `uvm_fatal("Build_phase","Failed to get FIFO_IF configuration")

if (!uvm_config_db #(virtual Interface_FIFO)::get(this, "", "FIFO_IF", FIFO_cfg.FIFO_vif)) begin
    `uvm_fatal("NO_VIF", "Virtual interface not found in configuration database")
    end
    
uvm_config_db#(virtual Interface_FIFO)::set(this, "*", "FIFO_IF_comps", FIFO_vif);
uvm_config_db#(FIFO_config_obj)::set(this, "*", "CFG", FIFO_cfg);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
test_finished = 0;
//Reset Sequence
`uvm_info("RUN_PHASE","Reset Started",UVM_LOW)
reset_seq.start(env.agt.sqr);
`uvm_info("RUN_PHASE","Reset Ended",UVM_LOW)
//Main Sequence
`uvm_info("RUN_PHASE","Main Started",UVM_LOW)
main_seq.start(env.agt.sqr);
`uvm_info("RUN_PHASE","Main Ended",UVM_LOW)
test_finished = 1;
phase.drop_objection(this);
endtask
endclass
endpackage