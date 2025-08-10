class seq_item_apb extends uvm_sequence_item;

	function new(string name = "seq_item_apb");
		super.new(name);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	
	//inputs
	rand bit 					PREADY;
	rand bit [31:0] 	PRDATA;

	//outputs
	bit [31:0]				PADDR;
	bit [31:0]				PWDATA;
	bit 							PSEL;
	bit 							PENABLE;
	bit 							PWRITE;

  the_config  comp_cfg;

  `uvm_object_utils_begin(seq_item_apb) 	//useful for printing, copying, comparing, packing/unpacking, and recording transactions
    `uvm_field_int(PREADY, UVM_ALL_ON|UVM_NOCOMPARE) //UVM_NOCOMPARE disables comparison — this is used because PREADY is an output from DUT, and we don’t want to compare expected vs. actual for it (it's not driven by the testbench).
    `uvm_field_int(PRDATA, UVM_ALL_ON|UVM_NOCOMPARE)

    `uvm_field_int(PWDATA, 	UVM_ALL_ON)	//UVM_ALL_ON enables all automation (print, copy, record, pack).
    `uvm_field_int(PSEL, 		UVM_ALL_ON)	
    `uvm_field_int(PENABLE, UVM_ALL_ON)	
    `uvm_field_int(PWRITE, 	UVM_ALL_ON)
  `uvm_object_utils_end

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  // task seq_item_apb_randomize();
	//  rx     = $urandom();
  // endtask : seq_item_apb_randomize

  function seq_item_apb clone;
	    seq_item_apb p;
	    $cast(p, super.clone());
	    return p;
  endfunction // clone

  virtual function void display_seq_item_apb(string name);
	    string msg;
	    
	    msg = $sformatf("\n\n This is being displayed from %s \n", name);
	    msg = {msg, $sformatf("================================================================\n")};
	    msg = {msg, $sformatf("PREADY= %0h, PRDATA= %0h \n", PREADY, PRDATA)};
	    msg = {msg, $sformatf("PADDR = %0h, PWDATA= %0h,PSEL= %0h,PENABLE= %0h,PWRITE = %0b \n", PADDR, PWDATA, PSEL, PENABLE, PWDATA)};
	    `uvm_info(name, msg, UVM_MEDIUM)
  endfunction // display_pkt

endclass : seq_item_apb