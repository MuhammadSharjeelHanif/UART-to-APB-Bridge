module apb_slave (
	input logic clk,

	input logic [31:0] PADDR,
	input logic [31:0] PWDATA,
	input logic        PSEL,
	input logic        PENABLE,
	input logic        PWRITE,

	output logic [31:0] PRDATA,
	output logic        PREADY

);

	logic [31:0] regfile [3:0];

	int addr;

	always_ff @(posedge clk ) begin
		// if (!rst_n) begin
		// 	regfile[0] <= 32'd0;
		// 	regfile[1] <= 32'd0;
		// 	regfile[2] <= 32'd0;
		// 	regfile[3] <= 32'd0;
		// 	PRDATA     <= 32'd0;
		// 	PREADY     <= 1'b0;
		// end 
		// else begin
			// $display("(from slave)PENABLE = %0b, PSEL = %0b, PREADY = %0b, PADDR = %0b, PWRITE = %0b, PWDATA= %0b, PRDATA = %0b", PENABLE, PSEL, PREADY, PADDR, PWRITE, PWDATA, PRDATA);

			if (PSEL && PENABLE) begin

				PREADY <= 1'b1;

				if (PWRITE) begin

					addr = PADDR;
					regfile[addr] <= PWDATA;

				end else begin

					addr = PADDR;
					PRDATA <= regfile[addr];

				end
			end else begin
				PREADY <= 1'b0;
			end
	end

endmodule
