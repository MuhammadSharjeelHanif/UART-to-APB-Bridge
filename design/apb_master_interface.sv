module apb_master_interface (
	input clk,    // Clock

	input  logic [31:0] 	addr,
	input  logic [31:0] 	wdata,
	input  logic 			write_en,
	input  logic 			start,
	input  logic 			ready,

	output logic [31:0] 	rdata,
	output logic 			done,

	//inputs from slaves
	input  logic 			PREADY,
	input  logic [31:0] 	PRDATA,
	// input  logic 			PSLVERR,
	
	//outputs to APB bus
	output logic [31:0]		PADDR,
	output logic [31:0]		PWDATA,
	output logic 			PSEL,
	output logic 			PWRITE,
	output logic 			PENABLE
);

	typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_3;
	state_3 state;

	always_ff @(posedge clk) begin : proc_
		// if(~rst_n) begin

			// state  	<= 	IDLE;
			// PADDR  	<= 	32'h0;
			// PWDATA  <= 32'h0;
			// PWRITE 	<= 	1'b0;
			// PSEL   	<= 	1'b0;
			// PENABLE <= 	1'b0;
			// rdata   <= 32'h0;
			// done 	<= 	1'b0;

		// end else begin
			
			 case (state)
			 	IDLE:
			 	begin
			 		PENABLE <= 	1'b0;
					done 	<= 	1'b0;

			 		if (start) begin
			 			PADDR 	<=	 addr;
			 			PWDATA 	<=	 wdata;
			 			PWRITE 	<=	 write_en;
			 			PSEL 	<=	 1'b1;
			 			state 	<=	 SETUP;
			 		end
			 	end

			 	SETUP:
			 	begin
			 		PENABLE <= 1'b1;
			 		state 	<= ACCESS;

			 	end

			 	ACCESS:
			 	begin

			 		if (PREADY) begin

			 			if (!PWRITE) rdata <= PRDATA;

			 			done 	<= 1'b1;
			 			PSEL 	<= 1'b0;
			 			PENABLE <= 1'b0;
			 			state 	<= IDLE;
			 		end
			 	end

			 	default: state <= IDLE;
			endcase
		
	end
endmodule : apb_master_interface