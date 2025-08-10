class out_monitor_apb extends  uvm_monitor;
	`uvm_component_utils(out_monitor_apb)

	function new(string name = "out_monitor_apb", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
  uvm_analysis_port#(seq_item_apb) mon_analysis_port;
  virtual the_out_intf_apb vif;
  
  seq_item_apb psig ;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  // =============================
  // Build Phase Method
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual the_out_intf_apb)::get(this, "", "the_out_intf_apb", vif)) // getting  the value from tb
      `uvm_fatal("OUT_MONITOR_apb", "Could not get vif")

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
      //   psig = seq_item_apb::type_id::create("OUT Monitor Pkt");
  		// 	// psig.w = vif.w;
  		// 	// psig.x = vif.x;
  		// 	// psig.y = vif.y;
  		// 	// psig.z = vif.z;
      //   mon_analysis_port.write(psig);
      //   psig.display_seq_item_apb("OUT_MONITOR_apb");      
  		// end
  	end
  endtask
endclass : out_monitor_apb