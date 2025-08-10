class inp_driver_apb extends uvm_driver#(seq_item_apb);
	`uvm_component_utils(inp_driver_apb)

	function new(string name = "inp_driver_apb", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	virtual the_inp_intf_apb vif;	// to send the values from here to DUT

	seq_item_apb psig;
/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  // =============================
  // Build Phase Method
  // =============================  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    psig = seq_item_apb::type_id::create("psig", this);

    // sqncr = uvm_sequencer#(seq_item_apb)::type_id::create("sqncr", this);

    if (!uvm_config_db#(virtual the_inp_intf_apb)::get(this, "", "the_in_intf_apb", vif))  // getting  the value from tb
      `uvm_fatal("INP_DRIVER_apb", "Could not get vif")

   endfunction // build_phase

  // =============================
  // Main Phase Method
  // =============================
  virtual task main_phase(uvm_phase phase);
	    super.main_phase(phase);

	    forever begin
	      seq_item_port.get_next_item(psig);
	      drive_item(psig);
	      seq_item_port.item_done();
	end

  endtask // main_phase

  virtual task drive_item(seq_item_apb drv_psig);

	    @(posedge vif.clk);
		`uvm_info("INP_DRIVER_apb", $sformatf("Driving a=%0d b=%0d c=%0d d=%0d", drv_comp.a, drv_comp.b, drv_comp.c, drv_comp.d), UVM_MEDIUM)
	      <= 0;
	      
	endtask // drive_item  
endclass : inp_driver_apb