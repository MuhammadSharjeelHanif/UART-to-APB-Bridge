interface the_out_intf_apb (input clk);
	
	logic [31:0]		PADDR;
	logic [31:0]		PWDATA;
	logic 				PSEL;
	logic 				PENABLE;
	logic 				PWRITE;
	
endinterface : the_out_intf_apb