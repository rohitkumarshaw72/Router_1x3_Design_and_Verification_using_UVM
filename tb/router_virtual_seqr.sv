
class router_virtual_seqr extends uvm_sequencer;
  
    `uvm_component_utils(router_virtual_seqr)

    router_source_seqr s_seqr[];
    router_dest_seqr d_seqr[];
    env_config m_cfg;

    function new(string name = "router_virtual_seqr", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
               `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db, have you set() it?")

        s_seqr = new[m_cfg.no_of_src_agt];
        d_seqr = new[m_cfg.no_of_dst_agt];
    endfunction
    
endclass
