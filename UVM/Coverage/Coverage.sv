package FIFO_coverage_pkg;

`include "uvm_macros.svh"
 import FIFO_item_pkg::*;
 import uvm_pkg::*;
 import shared_pkg::*;
class FIFO_coverage extends uvm_component;
`uvm_component_utils(FIFO_coverage)
 uvm_analysis_export #(FIFO_SequenceItem) cov_export;
 uvm_tlm_analysis_fifo #(FIFO_SequenceItem) cov_FIFO;
 FIFO_SequenceItem seq_item_cov;

covergroup Enable_Group;
WR_CVP : coverpoint seq_item_cov.wr_en;
RD_CVP : coverpoint seq_item_cov.rd_en;
cross WR_CVP,RD_CVP  {}
endgroup
covergroup BUS_IN_VALUES;
BUS_IN_CVP : coverpoint seq_item_cov.bus_in;
endgroup
covergroup FULL;
FULL_CVP: coverpoint seq_item_cov.full;
endgroup
covergroup EMPTY;
EMPTY_CVP: coverpoint seq_item_cov.empty;
endgroup
covergroup VALID;
VALID_CVP: coverpoint seq_item_cov.valid;
endgroup
covergroup BUS_OUT_VALUES;
BUS_OUT_CVP : coverpoint seq_item_cov.bus_out;
endgroup

 function new (string name = "FIFO_coverage",uvm_component parent = null);
 super.new(name, parent);
 Enable_Group = new();
 BUS_IN_VALUES = new();
 FULL = new();
 EMPTY = new();
 VALID = new();
 BUS_OUT_VALUES = new();
 endfunction
 function void build_phase (uvm_phase phase);
 super.build_phase(phase);
 cov_export = new("cov_export",this);
 cov_FIFO = new("cov_FIFO", this);
endfunction

 function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    cov_export.connect(cov_FIFO.analysis_export);
 endfunction
 task run_phase (uvm_phase phase);
 super.run_phase(phase);
 forever begin
    cov_FIFO.get(seq_item_cov);
    Enable_Group.sample();
    BUS_IN_VALUES.sample();
    FULL.sample();
    EMPTY.sample();
    VALID.sample();
    BUS_OUT_VALUES.sample();
 end
 endtask
endclass
endpackage