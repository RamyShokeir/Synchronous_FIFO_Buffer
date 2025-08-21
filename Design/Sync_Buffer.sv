import sync_fifo_pkg::*;
module FIFO
(
input logic clk,
input logic rst_n,
input logic [BUS_WIDTH-1:0] bus_in,
input logic wr_en,
input logic rd_en,
output logic [BUS_WIDTH-1:0] bus_out,
output logic valid,
output logic empty,
output logic full
);


logic [BUS_WIDTH-1:0] buffer_mem [BUFFER_DEPTH-1:0];

logic [$clog2(BUFFER_DEPTH)-1:0] wr_ptr;
logic [$clog2(BUFFER_DEPTH)-1:0] rd_ptr;
logic [$clog2(BUFFER_DEPTH):0] count;

assign full = (count == BUFFER_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if(({wr_en, rd_en} == 2'b11) && full) 
			count <= count - 1;		
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
	    else if(({wr_en, rd_en} == 2'b11) && empty)
			count <= count + 1; 	
	end
end
// Write Operation in Buffer Memory
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        wr_ptr <=0;
        // Reset The Buffer
        for (int i = 0; i<= BUFFER_DEPTH-1; i++)
        begin
            buffer_mem[i] <=0;
        end
    end
    else if(wr_en && !full)
    begin
        buffer_mem [wr_ptr] <= bus_in;
        wr_ptr <= wr_ptr + 'b1;
    end
end
// Read Operation  from Buffer Memory
always_ff @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        rd_ptr  <= 0;
        valid <=0;
        bus_out <= 0;
    end
    else if  (rd_en && !empty)
    begin
        bus_out <= buffer_mem [rd_ptr];
        valid<= 1'b1;
        rd_ptr <= rd_ptr + 'b1;
    end
    else
    begin
        bus_out <= 0;
        valid   <= 1'b0;
    end
end
endmodule