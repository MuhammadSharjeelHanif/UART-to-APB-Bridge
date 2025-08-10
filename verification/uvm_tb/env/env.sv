class the_env extends  uvm_env;
	
	`uvm_component_utils(the_env)

	function new(string name = "the_env", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
  inp_agent_uart               	ingr_agnt_uart    ;
  out_agent_uart               	egrs_agnt_uart    ;
  inp_agent_apb               	ingr_agnt_apb     ;
  out_agent_apb               	egrs_agnt_apb     ;

  scoreboard              			scrbrd        		;
  int                     			wd_timer      		;
  common_config           			common_cfg    		;
  uvm_event               			in_scb_evnt  			;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/

  // =============================
  // Build Phase Method
  // =============================
  	virtual function void build_phase(uvm_phase phase);
	    super.build_phase(phase);

	    // Creating Agents Scoreboard
	    ingr_agnt_uart   	= inp_agent_uart::type_id::create("ingr_agnt_uart", this);
	    egrs_agnt_uart   	= out_agent_uart::type_id::create("egrs_agnt_uart", this);
	    ingr_agnt_apb   	= inp_agent_apb::type_id::create("ingr_agnt_apb", this);
	    egrs_agnt_apb   	= out_agent_apb::type_id::create("egrs_agnt_apb", this);
	    scrbrd      			= scoreboard::type_id::create("scrbrd", this);
	    in_scb_evnt 			= uvm_event_pool::get_global("ingr_scb_event");

	    // Getting common_config
	    uvm_config_db #(common_config)::get(this, "*", "common_cfg", common_cfg);
	    
	    // Implicit Call for inp_sequence
	    uvm_config_db#(uvm_object_wrapper)::set(this,"ingr_agnt_uart.sqncr.main_phase", "default_sequence", inp_sequence::type_id::get());
  	endfunction  //build_phase


  // =============================
  // Connect Phase Method
  // =============================
  	virtual function void connect_phase(uvm_phase phase);
	    super.connect_phase(phase);
	    //connecting analysis port to scoreboard
	    ingr_agnt_uart.mntr.mon_analysis_port.connect(scrbrd.ingr_imp_export_uart);
	    egrs_agnt_uart.mntr.mon_analysis_port.connect(scrbrd.egrs_imp_export_uart);

	    // ingr_agnt_apb.mntr.mon_analysis_port.connect(scrbrd.ingr_imp_export_apb);
	    // egrs_agnt_apb.mntr.mon_analysis_port.connect(scrbrd.egrs_imp_export_apb);
  	endfunction  //connect_phase

  // =============================
  // Main Phase Method
  // =============================

	  virtual task main_phase(uvm_phase phase);
	    phase.raise_objection(this);
	    `uvm_info("the_env", "Starting main_phase.. ", UVM_MEDIUM)
	    super.main_phase(phase);

	    wd_timer = common_cfg.watchdog_timer;

	    fork
	      begin
	        #wd_timer;
	        `uvm_error("the_env", $sformatf("wd_timer Timed out"))
	      end
	      begin
	         in_scb_evnt.wait_trigger();
	         #500000; // idle time at the end of simulation
	        `uvm_info("the_env", "Scoreboard Verification Complete..", UVM_MEDIUM)
	      end
	    join_any
	    `uvm_info("the_env", "main_phase done.. ", UVM_MEDIUM)
	    phase.drop_objection(this);
 	endtask // main_phase
endclass : the_env