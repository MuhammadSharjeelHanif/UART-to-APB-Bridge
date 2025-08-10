class the_sequence extends uvm_sequence #(seq_item_uart);
	`uvm_object_utils(the_sequence)

	function new(string name = "the_sequence");
		super.new(name);
	endfunction : new
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	seq_item_uart receive;
	the_config the_cfg;
	int num_of_tx;
	int i;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  virtual task pre_start();

    if (!uvm_config_db#(the_config)::get(get_sequencer(), "", "the_cfg", the_cfg)) //
      `uvm_fatal("the_sequence", "Did not get the Config")
    $display("THE SEQ DETECTED");
  endtask 
  
  virtual task body();
    receive = seq_item_uart::type_id::create("receive");
    `uvm_info("the_sequence", $sformatf("Generating  = %0d", num_of_tx), UVM_MEDIUM)
    for (i = 0; i < num_of_tx; i++)  begin
        start_item(receive);
        receive.seq_item_uart_randomize(i);  // calling from seq item class
        // receive.the_cfg = the_cfg;    //not needed in this case 
        // if(!receive.randomize()) `uvm_fatal("cuboid_sequence", "receive Randomization Failed");
        finish_item(receive);
        `uvm_info("the_sequence", $sformatf("Done generation of %0d items", i+1), UVM_LOW)
    end 
    // for (i = 0; i < num_of_tx; i++)
    // `uvm_info("the_sequence", $sformatf("Done generation of %0d receive items", i), UVM_LOW)
  endtask // body

endclass : the_sequence