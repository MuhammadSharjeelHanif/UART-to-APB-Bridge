module uart_to_apb (
	input clk,    // Clock

	input logic rx,
	output logic tx,

	//APB Signals
	wire  logic 			PREADY,
	wire  logic [31:0] 		PRDATA,
	// input  logic 			PSLVERR,

	wire logic [31:0]		PADDR,
	wire logic [31:0]		PWDATA,
	wire logic 				PSEL,
	wire logic 				PENABLE,
	wire logic 				PWRITE
);

	//Transmitter
	logic [7:0]  tx_data;
	logic 		 tx_data_valid;
	logic		 tx_ready;

	//Reciever
	logic [7:0]  rx_data;
	logic 		 rx_data_valid;

	//signals going to apb master 
	logic [31:0] apb_addr;
    logic [31:0] apb_wdata;
    logic        apb_write_en;
    logic        apb_start;
    logic [31:0] apb_rdata;
    logic        apb_done;

    uart_rx urx(
    			.clk          (clk),
    			.rx           (rx),
    			.rx_data      (rx_data),
    			.rx_data_valid(rx_data_valid)
    	);

    uart_tx utx(
    			.clk          (clk),
    			.tx_data      (tx_data),
    			.tx           (tx),
    			.tx_ready     (tx_ready),
    			.tx_data_valid(tx_data_valid)
    	);

    apb_slave slave(
    				.clk    (clk),
    				.PREADY (PREADY),
    				.PRDATA (PRDATA),
    				.PWRITE (PWRITE),
    				.PENABLE(PENABLE),
    				.PSEL   (PSEL),
    				.PADDR  (PADDR),
    				.PWDATA (PWDATA)
    	);

    apb_master_interface ami(
    						 .clk      (clk),
        					 .addr     (apb_addr),
        					 .wdata    (apb_wdata),
        					 .write_en (apb_write_en),
        					 .start    (apb_start),
							 .rdata    (apb_rdata),
        					 .done     (apb_done),
        					 // .PSLVERR  (PSLVERR),
        					 .PREADY   (PREADY),
        					 .PADDR    (PADDR),
        					 .PWDATA   (PWDATA),
        					 .PWRITE   (PWRITE),
        					 .PSEL     (PSEL),
        					 .PENABLE  (PENABLE),
        					 .PRDATA   (PRDATA)
    	);

    typedef enum logic [1:0] {IDLE, WAIT_APB, TX_WAIT, READ_DATA} STATE_4;
    STATE_4 state = IDLE;
    
    always_ff @(posedge clk) begin : proc_
    	// if(~rst_n) begin

    		// state 			<= IDLE;
    		// apb_start 		<= 1'b0;
    		// tx_data_valid 	<= 1'b0;
    		// apb_addr      	<= 32'd0;
			// apb_wdata     	<= 32'd0;
			// apb_write_en  	<= 1'b0;
			// tx_data       	<= 8'd0;

    	// end 
    	// else begin

    		case (state)
    			IDLE:
    			begin
    				tx_data_valid <= 1'b0;
    				if (rx_data_valid) begin
    					apb_addr 		<= rx_data[2:1]; 
    					apb_wdata   	<= rx_data[7:3];
    					apb_write_en 	<= rx_data[0];
            			apb_start   	<= 1'b1;
    					state 			<= WAIT_APB;
    				end
    			end

    			WAIT_APB:
    			begin
    				apb_start <= 1'b0;
    				
    				if (apb_done) begin
 						tx_data = apb_write_en ? 8'h06 : {apb_rdata[4:0], apb_addr[1:0], 1'b1}; // ACK byte or data from slave
	                    state  <= TX_WAIT;
                    end 
    			end

    			TX_WAIT: 
    			begin
    				if (tx_ready) begin
    					tx_data_valid <= 1'b1;
    					state <= READ_DATA;
                		$display("TX_WAIT: Sending data = %0b", tx_data);

    				end
    			end
    			
    			READ_DATA:
    			begin
    				tx_data_valid <= 1'b0;

    				if (tx_ready) begin
    					state <= IDLE;
    				end
    			end
    		endcase
    end
endmodule : uart_to_apb