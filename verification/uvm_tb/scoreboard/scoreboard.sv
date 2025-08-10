// Implementation ports macros
`uvm_analysis_imp_decl(_ingr_uart)
`uvm_analysis_imp_decl(_egrs_uart)

// `uvm_analysis_imp_decl(_ingr_apb)
// `uvm_analysis_imp_decl(_egrs_apb)

class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	function new(string name = "scoreboard", uvm_component parent=null);
		super.new(name, parent);
	endfunction : new
/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
  uvm_analysis_imp_ingr_uart #(seq_item_uart, scoreboard) ingr_imp_export_uart;
  uvm_analysis_imp_egrs_uart #(seq_item_uart, scoreboard) egrs_imp_export_uart;

  // uvm_analysis_imp_ingr_apb #(seq_item_apb, scoreboard) ingr_imp_export_apb;
  // uvm_analysis_imp_egrs_apb #(seq_item_apb, scoreboard) egrs_imp_export_apb;

  seq_item_uart ingr_rec_q[$]; 

  uvm_event in_scb_evnt;
  common_config common_cfg;
  seq_item_uart exp_rec;
  seq_item_uart rec;

  int match, mismatch, ap_pp_ingr_rec_cnt;

  logic [7:0] memory[3]; 
  int addr;

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  // ============================================
  // Create implementation ports in build phase
  // ============================================

  	virtual function void build_phase(uvm_phase phase);
	    super.build_phase(phase);

	    ingr_imp_export_uart = new ("ingr_imp_export_uart", this);
	    egrs_imp_export_uart = new ("egrs_imp_export_uart", this);

	    // ingr_imp_export_apb = new ("ingr_imp_export_apb", this);
	    // egrs_imp_export_apb = new ("egrs_imp_export_apb", this);

	    in_scb_evnt     = uvm_event_pool::get_global("ingr_scb_event");

	    // getting common config
	    uvm_config_db #(common_config)::get(this, "*", "common_cfg", common_cfg);

	endfunction // build_phase

	virtual function void write_ingr_uart(seq_item_uart rec);
		if (rec.rx[0]) begin
			rec.tx = 8'h06;
			addr = rec.rx[2:1];
			memory[addr] = rec.rx;
		end
		
		else begin
			addr = rec.rx[2:1];
			rec.tx = memory[addr];
		end
		ingr_rec_q.push_back(rec);
		ap_pp_ingr_rec_cnt++;
	endfunction : write_ingr_uart

	virtual function void write_egrs_uart(seq_item_uart rec);
	    if (ingr_rec_q.size() == 0)
	      `uvm_error("SCB", $sformatf("Data not Present"))
	    else 
	      exp_rec = ingr_rec_q.pop_front();

		if (rec.compare(exp_rec)) begin
			$display("MATCH");
			match++;
		end
		else begin
			mismatch++;
			display_mismatch_data(exp_rec, rec);
		end
	endfunction : write_egrs_uart

  // ========================================
  // Main Phase Task
  // ========================================
  	virtual task main_phase(uvm_phase phase);
	    super.main_phase(phase);
	    wait(common_cfg.inp_num_tx == match + mismatch );
	    in_scb_evnt.trigger();
  	endtask // main_phase


  // ========================================
  // Report Phase Task
  // ========================================
  	virtual function void report_phase (uvm_phase phase);
    	`uvm_info("SCB", $sformatf("Matched=%0d, Mismatched=%0d", match, mismatch), UVM_MEDIUM)
  	endfunction // report_phase


  	virtual function void display_mismatch_data(seq_item_uart exp_rec, seq_item_uart rec );
	    string   msg;
	    
	    msg = $sformatf("\nMismatch: Exp tx = %0b Actual tx = %0b \n", exp_rec.tx, rec.tx);
	    msg = {msg, $sformatf("==============================================================================================\n")};
	    `uvm_error("mismatch number", msg)
  	endfunction  

endclass : scoreboard