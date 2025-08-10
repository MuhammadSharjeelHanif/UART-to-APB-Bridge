class inp_agent_uart extends  uvm_agent;
	`uvm_component_utils(inp_agent_uart)

	function new(string name = "inp_agent_uart", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	
	inp_monitor_uart mntr;
	inp_driver_uart drvr;
	uvm_sequencer # (seq_item_uart) sqncr;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/

  // =============================
  // Build Phase Method
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sqncr = uvm_sequencer#(seq_item_uart)::type_id::create("sqncr", this);
    mntr = inp_monitor_uart::type_id::create("mntr", this);
    drvr = inp_driver_uart::type_id::create("drvr", this);
  endfunction


  // =============================
  // Connect Phase Method
  // =============================
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drvr.seq_item_port.connect(sqncr.seq_item_export);
    `uvm_info("AGENT", "Driver connected to sequencer", UVM_LOW)

  endfunction

endclass : inp_agent_uart