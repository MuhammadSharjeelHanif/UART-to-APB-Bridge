class inp_monitor_uart extends uvm_monitor;
	`uvm_component_utils(inp_monitor_uart)

	function new(string name = "inp_monitor_uart", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	uvm_analysis_port#(seq_item_uart) mon_analysis_port; // defined in env(cnnected to scoreboard)
	virtual the_inp_intf_uart vif;  // to get values from here and put it in mon_analysis_port
  int baud_delay = 868;

	seq_item_uart rec;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  // =============================
  // Build Phase Method
  // =============================
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db#(virtual the_inp_intf_uart)::get(this, "", "the_in_intf_uart", vif)) // getting  the value from tb
      `uvm_fatal("INP_MONITOR_uart", "Could not get vif")
    
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
    bit [7:0] data;

  	forever begin
      @(posedge vif.clk);

  		if (!vif.rx) begin
        repeat(baud_delay + (baud_delay / 2)) @(posedge vif.clk);

        for (int i = 0; i < 8; i++) begin
          data[i] = vif.rx;
          repeat(baud_delay) @(posedge vif.clk);
        end

        rec = seq_item_uart::type_id::create("INP Monitor Pkt");
  			rec.rx = data;
        mon_analysis_port.write(rec);
        rec.display_seq_item_uart("INPUT_MONITOR");
  		end
  	end
  endtask
endclass : inp_monitor_uart