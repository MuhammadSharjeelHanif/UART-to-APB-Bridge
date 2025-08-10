class the_config extends uvm_component;
/*-------------------------------------------------------------------------------
-- FR & C
-------------------------------------------------------------------------------*/
  int config_1;
  int config_2;

	`uvm_component_utils_begin(the_config)
	  `uvm_field_int(config_1  ,  UVM_DEC)
  	 `uvm_field_int(config_2  ,  UVM_DEC)
    `uvm_component_utils_end  

	function new(string name = "the_config", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new
	
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
  	uvm_cmdline_processor clp = uvm_cmdline_processor::get_inst();

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  function void post_randomize();
    string arg_value;
    super.post_randomize();
    if(clp.get_arg_value("+config_1=" , arg_value)) config_1 = arg_value.atoi();
    if(clp.get_arg_value("+config_2=" , arg_value)) config_2 = arg_value.atoi(); 

  endfunction // post_randomize

endclass : the_config