package FIFO_scoreboard_pkg;
  import shared_pkg::*;
  import FIFO_item_pkg::*;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  class FIFO_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(FIFO_scoreboard)

    uvm_analysis_export #(FIFO_SequenceItem) sb_export;
    uvm_tlm_analysis_fifo #(FIFO_SequenceItem) sb_FIFO;

    FIFO_SequenceItem seq_item_sb;

    // Reference model state
    logic [BUS_WIDTH-1:0] reference_queue[$];
    logic [BUS_WIDTH-1:0] bus_out_ref;
    logic valid_ref;
    logic empty_ref;
    logic full_ref;

    function new(string name = "FIFO_scoreboard", uvm_component parent = null);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      sb_export = new("sb_export", this);
      sb_FIFO   = new("sb_FIFO", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      sb_export.connect(sb_FIFO.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        sb_FIFO.get(seq_item_sb);

        // update reference model
        ref_model(seq_item_sb);

        // Compare DUT vs REF
        if (seq_item_sb.bus_out != bus_out_ref ||
            seq_item_sb.valid   != valid_ref   ||
            seq_item_sb.empty   != empty_ref   ||
            seq_item_sb.full    != full_ref) begin

          `uvm_error("RUN_PHASE",$sformatf("bus_out = 0%h , bus_ref = 0%h",seq_item_sb.bus_out,bus_out_ref));
          `uvm_error("RUN_PHASE",$sformatf("valid = 0%b , valid_ref = 0%b",seq_item_sb.valid,valid_ref));
          `uvm_error("RUN_PHASE",$sformatf("full = 0%b , full_ref = 0%b",seq_item_sb.full,full_ref));
          `uvm_error("RUN_PHASE",$sformatf("empty = 0%b , empty_ref = 0%b",seq_item_sb.empty,empty_ref));
          error_count++;
        end
        else begin
          `uvm_info("RUN_PHASE",$sformatf("Correct FIFO_out: %s", seq_item_sb.convert2string()), UVM_HIGH);
          correct_count++;
        end
      end
    endtask

    // Unified reference model
    function void ref_model(FIFO_SequenceItem seq_item_chk);
      if (!seq_item_chk.rst_n) begin
        reference_queue.delete();
        bus_out_ref = 0;
        valid_ref   = 0;
        empty_ref   = 1;
        full_ref    = 0;
      end
      else begin
        valid_ref = 0; // default
        // Read + Write
        if (seq_item_chk.wr_en && seq_item_chk.rd_en) 
        begin
          if(reference_queue.size() == BUFFER_DEPTH)
          begin
            bus_out_ref = reference_queue.pop_front();
            valid_ref   = 1;  
          end
          else if (reference_queue.size() > 0)
          begin
            reference_queue.push_back(seq_item_chk.bus_in);
            bus_out_ref = reference_queue.pop_front();
            valid_ref   = 1;  
          end
          else if (reference_queue.size() == 0)
          begin
                reference_queue.push_back(seq_item_chk.bus_in);
                bus_out_ref = 0;
                valid_ref = 0;
          end
          else
          begin
            bus_out_ref = 0;
            valid_ref = 0;
          end

        end
        // Write only
        else if (seq_item_chk.wr_en && !seq_item_chk.rd_en) begin
          if (reference_queue.size() < BUFFER_DEPTH)
            reference_queue.push_back(seq_item_chk.bus_in);
            bus_out_ref = 0;
            valid_ref = 0;
        end
        // Read only
        else if (!seq_item_chk.wr_en && seq_item_chk.rd_en) begin
          if (reference_queue.size() > 0) begin
            bus_out_ref = reference_queue.pop_front();
            valid_ref   = 1;
          end
          else
          begin
            bus_out_ref = 0;
            valid_ref = 0;
          end
        end
        else
        begin
            bus_out_ref = 0;
            valid_ref = 0;
        end
        // Update flags
        empty_ref = (reference_queue.size() == 0);
        full_ref  = (reference_queue.size() == BUFFER_DEPTH);
      end
    endfunction

    function void report_phase(uvm_phase phase);
      super.report_phase(phase);
      if (test_finished == 1) begin
        `uvm_info("REPORT_PHASE", $sformatf("Total Correct Comparisons: %d", correct_count), UVM_MEDIUM);
        `uvm_info("REPORT_PHASE", $sformatf("Total Error Comparisons: %d", error_count), UVM_MEDIUM);
      end
    endfunction

  endclass
endpackage
