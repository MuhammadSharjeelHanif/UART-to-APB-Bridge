module uart_rx (
	input 				clk,    // Clock
	// input 				rst_n,  // Asynchronous reset active low

	input  logic				rx,
	output logic 	[7:0]  		rx_data,
	output logic 				rx_data_valid	
);

	logic [3:0] 		bit_counter;
	logic [7:0]			shift_reg;
	logic [15:0] 		baud_counter;

	localparam baud_divisor = 100000000 / (115200);
	
	typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_1;
	state_1 state;
	
	always_ff @(posedge clk) begin 
		// if(~rst_n) begin

			// state <= IDLE;
			// rx_data <= 8'b0;
			// rx_data_valid <= 1'b0;
			// bit_counter <= 0;
			// shift_reg <= 8'b0;
			// baud_counter <= 16'b0;

		// end else begin
			rx_data_valid <= 0;

			case (state)
				IDLE:
				begin
					if (!rx)begin
						state <= START;
						baud_counter <= baud_divisor / 2;
					end
				end

				START:
				begin
					if (baud_counter == 0) begin
						if (!rx) begin
							state <= DATA;
							bit_counter <= 0;
							baud_counter <= baud_divisor;
						end
						else
							state <= IDLE;
					end
					else
						baud_counter <= baud_counter - 1;
				end

				DATA:
				begin
					if (baud_counter == 0) begin
						shift_reg[bit_counter] <= rx;
						baud_counter <= baud_divisor;
						if (bit_counter == 7) begin
							state <= STOP;
						end
						else begin
							bit_counter <= bit_counter + 1;	
						end	
					end
					else begin
						baud_counter <= baud_counter - 1;
					end
				end

				STOP:
				begin
					if (baud_counter == 0) begin
						rx_data <= shift_reg;
						rx_data_valid <= 1'b1;
						state <= IDLE;
					end
					else begin
						baud_counter <= baud_counter - 1;
					end
				end

				default: state <= IDLE;
			endcase
	end
endmodule : uart_rx

