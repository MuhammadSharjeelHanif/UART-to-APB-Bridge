class out_agent_uart extends  uvm_agent;

	`uvm_component_utils(out_agent_uart)
	function new(string name = "out_agent_uart", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	out_monitor_uart mntr;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  // =============================
  // Build Phase Method
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mntr = out_monitor_uart::type_id::create("mntr", this);
  endfunction


  // =============================
  // Connect Phase Method
  // =============================
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  endfunction

endclass : out_agent_uart