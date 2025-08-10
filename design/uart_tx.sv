module uart_tx
 (
	input  logic 		clk,    // Clock

	input  logic [7:0]  tx_data,
	input  logic 		tx_data_valid,

	output logic 		tx,
	output logic 		tx_ready
);

 	typedef enum logic [1:0] {IDLE, START, DATA, STOP} STATE_2;

 	STATE_2			state = IDLE;
 	logic [3:0]		bit_counter;
 	logic [15:0]	baud_counter;
 	logic [7:0] 	shift_reg;
 	
 	localparam baud_divisor = 100000000 / 115200;


 	always_ff @(posedge clk) begin

 		tx_ready <= (state == IDLE);
 		// if(~rst_n) begin

 			// state 			<= 		IDLE;
 			// shift_reg 		<= 		0;
 			// baud_counter 	<= 		0;
 			// bit_counter 	<= 		0;
 			// tx 				<= 		1'b1;		// idle 

 		// end else begin
 			case (state)
 				IDLE:
 				begin
 					tx <= 1'b1;
 					if (tx_data_valid) begin
 						shift_reg 		<= tx_data;
 						baud_counter 	<= baud_divisor - 1;
 						state 			<= START;
 					end
 				end

 				START:
 				begin
 					tx <= 1'b0;  		// start bit
 					if (baud_counter == 0) begin
 						state 			<= DATA;
 						bit_counter 	<= 0;
 						baud_counter 	<= baud_divisor - 1;
 					end

 					else
 						baud_counter <= baud_counter - 1;
 				end

 				DATA:
 				begin
 					tx <= shift_reg[0];

 					if (baud_counter == 0) begin
 						if (bit_counter < 7) begin
 							shift_reg 		<= shift_reg >> 1;
 							baud_counter 	<= baud_divisor-1;
 							bit_counter 	<= bit_counter + 1;
 						end
 						else begin
 							shift_reg <= shift_reg >> 1;
 							state <= STOP;
 							baud_counter <= baud_divisor-1;
 						end
 					end

 					else
 						baud_counter <= baud_counter - 1;
 				end

 				STOP: 
 				begin
	 				tx <= 1'b1;  		// stop bit
 					if (baud_counter == 0) begin
 						state <= IDLE;
 					end
 					else
 						baud_counter <= baud_counter - 1;
 				end

 				default: state <= IDLE;
 			endcase
 		
 	end
endmodule : uart_tx
