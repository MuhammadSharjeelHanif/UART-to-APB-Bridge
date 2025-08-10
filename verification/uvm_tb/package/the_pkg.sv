package the_pkg;
 `include "uvm_macros.svh"
  import uvm_pkg::*;
	
  //configs
  `include "the_config.sv"
  `include "common_config.sv"
  // Sequence Item
  `include "seq_item_uart.sv"
  `include "seq_item_apb.sv"
  // Drivers
  `include "inp_driver_uart.sv"
  // Monitor
  `include "inp_monitor_uart.sv"
  `include "inp_monitor_apb.sv"
  `include "out_monitor_uart.sv"
  `include "out_monitor_apb.sv"
  // Agents 
  `include "inp_agent_uart.sv"
  `include "out_agent_uart.sv"
  `include "inp_agent_apb.sv"
  `include "out_agent_apb.sv"
  // Scoreboard
  `include "scoreboard.sv"
  // Sequences
  `include "the_sequence.sv"
  `include "inp_sequence.sv"
  // Enironment 
  `include "env.sv"
  // Tests
  `include "base_test.sv"
  `include "../test/new_test/test.sv"
endpackage : the_pkg