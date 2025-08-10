`timescale 1ns/1ps

module tb_uart_to_apb;
	import uvm_pkg::*;
	import the_pkg::*;
	
// ====================================
// testbench signals
// ====================================

	bit clk = 0;

// ====================================
// Interface instant
// ====================================

	the_inp_intf_uart the_inp_if_uart (.clk(clk));
	the_out_intf_uart the_out_if_uart (.clk(clk));

	the_inp_intf_apb the_inp_if_apb (.clk(clk));
	the_out_intf_apb the_out_if_apb (.clk(clk));

// ====================================
// Design instant
// ====================================

	uart_to_apb tb_inst(
		.clk  				(clk),
		.rx						(the_inp_if_uart.rx),
		.tx 					(the_out_if_uart.tx),
		.PREADY				(the_inp_if_apb.PREADY),
		.PRDATA				(the_inp_if_apb.PRDATA),
		.PADDR				(the_out_if_apb.PADDR),
		.PENABLE			(the_out_if_apb.PENABLE),
		.PSEL					(the_out_if_apb.PSEL),
		.PWDATA				(the_out_if_apb.PWDATA),
		.PWRITE				(the_out_if_apb.PWRITE)
	);

// ====================================
// Initial Block
// ====================================

	initial begin
		uvm_config_db#(virtual the_inp_intf_uart)::set(null, "uvm_test_top.env.ingr_agnt_uart.drvr", "the_in_intf_uart", the_inp_if_uart);
		uvm_config_db#(virtual the_inp_intf_uart)::set(null, "uvm_test_top.env.ingr_agnt_uart.mntr", "the_in_intf_uart", the_inp_if_uart);
		uvm_config_db#(virtual the_out_intf_uart)::set(null, "uvm_test_top.env.egrs_agnt_uart.mntr", "the_out_intf_uart", the_out_if_uart);
		uvm_config_db#(virtual the_inp_intf_uart)::set(null, "uvm_test_top"							, "the_in_intf_uart", the_inp_if_uart);

		// uvm_config_db#(virtual the_inp_intf_apb)::set(null, "uvm_test_top.env.ingr_agnt_apb.drvr", "the_in_intf_apb", the_inp_if_apb);
		uvm_config_db#(virtual the_inp_intf_apb)::set(null, "uvm_test_top.env.ingr_agnt_apb.mntr", "the_in_intf_apb", the_inp_if_apb);
		uvm_config_db#(virtual the_out_intf_apb)::set(null, "uvm_test_top.env.egrs_agnt_apb.mntr", "the_out_intf_apb", the_out_if_apb);
		uvm_config_db#(virtual the_inp_intf_apb)::set(null, "uvm_test_top"						, "the_in_intf_apb", the_inp_if_apb);
		run_test();
	end

// ====================================
// Clock generation
// ====================================
always 
  #5 clk = ~clk ;

endmodule : tb_uart_to_apb