class common_config extends uvm_component;
/*-------------------------------------------------------------------------------
-- FR & C
-------------------------------------------------------------------------------*/
	int inp_num_tx;
	int watchdog_timer;

	`uvm_component_utils_begin(common_config)
	`uvm_field_int(inp_num_tx  ,  UVM_DEC)
	`uvm_field_int(watchdog_timer  ,  UVM_DEC)
	`uvm_component_utils_end  

	function new(string name = "common_config", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
  	uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();


/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
	function void build_phase (uvm_phase phase);
	  get_plusarg("inp_num_tx", inp_num_tx);
	  get_plusarg("watchdog_timer", watchdog_timer);
	endfunction 


	function automatic void get_plusarg(string arg_name, ref int arg_value);
	   if ($value$plusargs({arg_name, "=%d"}, arg_value)) begin
	       `uvm_info("CONFIG", $sformatf("%s: %d", arg_name, arg_value), UVM_MEDIUM)
	   end else begin
	       `uvm_fatal("CONFIG", $sformatf("Plusarg %s not provided", arg_name))
	   end
	endfunction

endclass : common_config