
package router_pkg;

    import uvm_pkg::*;
    
    `include "uvm_macros.svh"
    `include "source_xtn.sv"
    `include "source_config.sv"
    `include "dest_config.sv"
    `include "env_config.sv"
    
    `include "router_source_driver.sv"
    `include "router_source_monitor.sv"
    `include "router_source_seqr.sv"
    `include "router_source.sv"
    `include "router_source_agent_top.sv"
    `include "router_source_seq.sv"
    
    `include "dest_xtn.sv"

    `include "router_dest_monitor.sv"
    `include "router_dest_seqr.sv"
    `include "router_dest_seq.sv"
    `include "router_dest_driver.sv"
    `include "router_dest.sv"
    `include "router_dest_agent_top.sv"
    
    `include "router_virtual_seqr.sv"
    `include "router_scoreboard.sv"
    
    `include "router_env.sv"

    `include "router_test.sv"
    
    
endpackage
