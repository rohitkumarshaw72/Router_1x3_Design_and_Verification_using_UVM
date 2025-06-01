
class router_dest_agent_top extends uvm_env;

    `uvm_component_utils(router_dest_agent_top)
    
    router_dest agth[];
    env_config m_cfg;
    
    extern function new(string name="router_dest_agent_top", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    
endclass

function router_dest_agent_top::new(string name="router_dest_agent_top", uvm_component parent);
    super.new(name, parent);
endfunction

function void router_dest_agent_top::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(env_config)::get(this,"","env_config",m_cfg))
        `uvm_fatal(get_type_name(), "ENV: source error")
    agth = new[m_cfg.no_of_dst_agt];
    
    foreach(agth[i])  begin
        agth[i] = router_dest::type_id::create($sformatf("agth[%0d]",i),this);
        uvm_config_db #(dest_config)::set(this,$sformatf("agth[%0d]*",i),"dest_config", m_cfg.dst_cfg[i]);

    end
endfunction
