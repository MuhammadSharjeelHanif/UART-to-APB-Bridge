class base_test extends  uvm_test;
	`uvm_component_utils(base_test)

	function new(string name = "base_test", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
  the_env            env          ;
  common_config      common_cfg   ;
  the_config         the_cfg      ;

  virtual the_inp_intf_uart the_in_intf;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/

  // =============================
  // Build Phase Method
  // =============================
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);	

  		common_cfg = common_config::type_id::create("common_cfg", this);
      the_cfg  = the_config::type_id::create("the_cfg", this);

    	uvm_config_db #(common_config)::set(null, "*", "common_cfg", common_cfg);
   		uvm_config_db #(the_config)::set(null, "*", "the_cfg", the_cfg);

	    env = the_env::type_id::create("env", this);

	    // getting virtual interfaces for vif_init_zero tasks
	    if (!uvm_config_db#(virtual the_inp_intf_uart)::get(this, "", "the_in_intf_uart", the_in_intf))
	      `uvm_fatal("TEST", "Did not get the_in_intf")
	endfunction

  // =============================
  // Reset Phase Method
  // =============================
  virtual task reset_phase(uvm_phase phase);
    phase.raise_objection(this);

    `uvm_info("base_test", $sformatf("Staring reset_phase.."), UVM_MEDIUM)
    super.reset_phase(phase);
    vif_init_zero(); 
    `uvm_info("base_test", $sformatf("reset_phase done.."), UVM_MEDIUM)
    repeat (100) @(posedge the_in_intf.clk); //idle cycles
    phase.drop_objection(this);
  endtask // reset_phase

  // ==============================================
  // all interfaces needs to intialize with zeros
  // ==============================================
  task vif_init_zero();
    the_in_intf.rx   <= 1 ;
  endtask

endclass : base_test