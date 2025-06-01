
class router_source_agent_top extends uvm_env;

    `uvm_component_utils(router_source_agent_top)
    
    //agent handle
    router_source agth[];
    env_config m_cfg;
    
    extern function new(string name="router_source_agent_top", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    
endclass


function router_source_agent_top::new(string name="router_source_agent_top", uvm_component parent);
    super.new(name, parent);
endfunction

function void router_source_agent_top::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
        `uvm_fatal(get_type_name(), "ENV: source error")
    agth = new[m_cfg.no_of_src_agt];
    
    foreach(agth[i])  begin
        agth[i] = router_source::type_id::create($sformatf("agth[%0d]",i),this);
        uvm_config_db #(source_config)::set(this,$sformatf("agth[%0d]*",i),"source_config", m_cfg.src_cfg[i]);

    end
endfunction
