class inp_driver_uart extends uvm_driver#(seq_item_uart);
	`uvm_component_utils(inp_driver_uart)

	function new(string name = "inp_driver_uart", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual the_inp_intf_uart vif;	// to send the values from here to DUT
	int baud_delay = 868;
	seq_item_uart rec;
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  // =============================
  // Build Phase Method
  // =============================  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    rec = seq_item_uart::type_id::create("rec", this);

    // sqncr = uvm_sequencer#(seq_item_uart)::type_id::create("sqncr", this);

    if (!uvm_config_db#(virtual the_inp_intf_uart)::get(this, "", "the_in_intf_uart", vif))  // getting  the value from tb
      `uvm_fatal("INP_DRIVER_uart", "Could not get vif")

  endfunction // build_phase

  // =============================
  // Main Phase Method
  // =============================
  virtual task main_phase(uvm_phase phase);
	    super.main_phase(phase);

	    forever begin
	      seq_item_port.get_next_item(rec);
	      drive_item(rec);
	      seq_item_port.item_done();
			end
  endtask // main_phase

  virtual task drive_item(seq_item_uart drv_rec);

  	bit [9:0] frame;
  	bit [7:0] uart_data = drv_rec.rx;
  	frame = {1'b1, uart_data, 1'b0};  // start bit, data, stop bit

  	for (int i = 0; i < 10; i++) begin
	    vif.rx = frame[i];
	    repeat(baud_delay) @(posedge vif.clk);
  	end
	    vif.rx = 1'b1; // idle state
	endtask // drive_item  
endclass : inp_driver_uart