class seq_item_uart extends uvm_sequence_item;

	function new(string name = "seq_item_uart");
		super.new(name);
	endfunction : new

/*-------------------------------------------------------------------------------
-- Interface, port, fields
-------------------------------------------------------------------------------*/
	
  rand bit [7:0]      rx;
  bit      [7:0]      tx;

  the_config  the_cfg;

  `uvm_object_utils_begin(seq_item_uart)
    `uvm_field_int(rx, UVM_ALL_ON|UVM_NOCOMPARE)
    `uvm_field_int(tx, UVM_ALL_ON)
  `uvm_object_utils_end

/*-------------------------------------------------------------------------------
-- Functions
-------------------------------------------------------------------------------*/
  task seq_item_uart_randomize(int i);
    if (i < 3) begin
      rx[0] = 1; // First 3 transctions as write operations 
      case (i)
        0: rx[2:1] = 00;
        1: rx[2:1] = 01;
        2: rx[2:1] = 10;
      endcase
      // rx[7:3] = $urandom_range(0,15);
      rx[7:3] = $urandom_range(0,31);
      
    end else begin
      rx[0] = 0; // other three to read the above writtten transactions
      case (i)
        3: rx[2:1] = 00;
        4: rx[2:1] = 01;
        5: rx[2:1] = 10;
      endcase
      // rx[7:3] = $urandom_range(0,15);
      rx[7:3] = 0;
    end
  endtask : seq_item_uart_randomize

  function seq_item_uart clone;
	    seq_item_uart p;
	    $cast(p, super.clone());
	    return p;
  endfunction // clone

  virtual function void display_seq_item_uart(string name);
	    string msg;
	    
	    msg = $sformatf("\n\n This is being displayed  from %s \n", name);
	    msg = {msg, $sformatf("================================================================\n")};
	    msg = {msg, $sformatf("rx = %b \n", rx)};
	    msg = {msg, $sformatf("tx = %b \n", tx)};
      msg = {msg, $sformatf("================================================================\n")};
	    `uvm_info(name, msg, UVM_MEDIUM)
  endfunction // display_pkt

endclass : seq_item_uart