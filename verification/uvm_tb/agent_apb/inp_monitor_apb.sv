class inp_monitor_apb extends uvm_monitor;
	`uvm_component_utils(inp_monitor_apb)

	function new(string name = "inp_monitor_apb", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	uvm_analysis_port#(seq_item_apb) mon_analysis_port; // defined in env(cnnected to scoreboard)
	virtual the_inp_intf_apb vif;  // to get values from here and put it in mon_analysis_port

	seq_item_apb comp;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  // =============================
  // Build Phase Method
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(virtual the_inp_intf_apb)::get(this, "", "the_in_intf_apb", vif)) // getting  the value from tb
      `uvm_fatal("INP_MONITOR_apb", "Could not get vif")
    
    mon_analysis_port = new ("mon_analysis_port", this);
  endfunction // build_phase


  // =============================
  // Main Phase Method
  // =============================
  virtual task main_phase(uvm_phase phase);
    super.main_phase(phase);
    fork
      collect_data();
    join_none
    
  endtask // main_phase

  // =============================
  // Collecting data
  // =============================
  task collect_data;
  	forever begin
      @(posedge vif.clk);
  		// if (vif.valid) begin
      //   comp = seq_item_apb::type_id::create("INP Monitor Pkt");
  		// 	// comp.a = vif.a;
  		// 	// comp.b = vif.b;
  		// 	// comp.c = vif.c;
  		// 	// comp.d = vif.d;
      //   mon_analysis_port.write(comp);
      //   comp.display_seq_item_apb("INPUT_MONITOR_apb");      
  		// end
  	end
  endtask
endclass : inp_monitor_apb