import  shared_pkg::*;
module FIFO (Interface_FIFO.DUT Interface_Handle);
    logic clk;
    logic rst_n;
    logic [BUS_WIDTH-1:0] bus_in;
    logic wr_en;
    logic rd_en;
    logic [BUS_WIDTH-1:0] bus_out;
    logic valid;
    logic empty;
    logic full;

assign clk = Interface_Handle.CLK;
assign rst_n = Interface_Handle.rst_n;
assign bus_in = Interface_Handle.bus_in;
assign wr_en = Interface_Handle.wr_en;
assign rd_en = Interface_Handle.rd_en;
assign Interface_Handle.full = full;
assign Interface_Handle.empty = empty;
assign Interface_Handle.bus_out = bus_out;
assign Interface_Handle.valid = valid;

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