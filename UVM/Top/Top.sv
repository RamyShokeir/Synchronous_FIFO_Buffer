import FIFO_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module Top_FIFO();
bit CLK;
//CLOCK GENERATION
initial
begin
CLK = 0;
forever
#5 CLK = ~CLK;
end
Interface_FIFO Interface_Handle (CLK);
FIFO DUT (Interface_Handle);
bind FIFO FIFO_SVA  FIFO_SVA_Bind (.Interface_Handle(Interface_Handle));
initial
begin
uvm_config_db#(virtual Interface_FIFO)::set(null,"uvm_test_top","FIFO_IF",Interface_Handle);
run_test("FIFO_test");
end
endmodule