class inp_sequence extends uvm_sequence # (seq_item_uart);
	`uvm_object_utils(inp_sequence)

	function new(string name = "inp_sequence");
		super.new(name);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
  the_sequence the_seq ;
  common_config   common_cfg;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  // Get common_config
  	virtual task pre_start();
  	$display("inp_sequence pre start");
	    if (!uvm_config_db#(common_config)::get(get_sequencer(), "", "common_cfg", common_cfg))
	      `uvm_fatal("inp_sequence", "Did not get common_config")
	    else begin
    		`uvm_info("inp_sequence", $sformatf("Successfully got common_cfg with inp_num_tx = %0d", common_cfg.inp_num_tx), UVM_MEDIUM)
			end
 	endtask : pre_start

 	virtual task body();
	    `uvm_info("inp_sequence", $sformatf("Starting the_seq for %0d packets..", common_cfg.inp_num_tx), UVM_MEDIUM)

	    the_seq = the_sequence::type_id::create("the_seq");
	    the_seq.num_of_tx = common_cfg.inp_num_tx ; 
	    the_seq.start(get_sequencer());
	    
	    `uvm_info("inp_sequence", $sformatf("the_seq done.."), UVM_MEDIUM)
  	endtask 
endclass : inp_sequence