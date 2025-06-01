
class router_env extends uvm_env;

    `uvm_component_utils(router_env)
    
    router_source_agent_top src_agt_top;
    router_dest_agent_top dst_agt_top;
    
    router_virtual_seqr v_seqr;
    
    router_scoreboard sb;
    
    env_config m_cfg;
    
    
    extern function new(string name="router_env", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    
endclass: router_env

function router_env::new(string name="router_env", uvm_component parent);
    super.new(name, parent);
endfunction

function void router_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
        `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db, have you set() it?")
    
    begin
        src_agt_top = router_source_agent_top::type_id::create("src_agt_top",this);
    end
    
    begin
        dst_agt_top = router_dest_agent_top::type_id::create("dst_agt_top",this);
    end
    
    if(m_cfg.has_virtual_sequencer)  begin
        v_seqr = router_virtual_seqr::type_id::create("v_seqr",this);
    end
    if(m_cfg.has_scoreboard)  begin
        sb = router_scoreboard::type_id::create("sb",this);
    end
    
endfunction


function void router_env::connect_phase(uvm_phase phase);
    
    for(int i=0;i<m_cfg.no_of_src_agt;i++)
        v_seqr.s_seqr[i] = src_agt_top.agth[i].s_seqr;
    
    for(int i=0;i<m_cfg.no_of_dst_agt;i++)
        v_seqr.d_seqr[i] = dst_agt_top.agth[i].d_seqr;
        
    super.connect_phase(phase);
    `uvm_info("ROUTER_ENV","This is connect phase of router_env", UVM_LOW)
endfunction


function void router_env::end_of_elaboration_phase(uvm_phase phase);
    m_cfg=env_config::type_id::create("m_cfg");

    super.end_of_elaboration_phase(phase);
    `uvm_info("ROUTER_ENV","This is end_of_elaboration phase of router_env", UVM_LOW)
endfunction


task router_env::run_phase(uvm_phase phase);
    super.run();
    phase.raise_objection(this);
    #100;
    `uvm_info("ROUTER_ENV", "This is run phase in router_env", UVM_LOW)
    phase.drop_objection(this);
endtask
