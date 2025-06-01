
class router_dest extends uvm_agent;
    
    `uvm_component_utils(router_dest)
    
    dest_config dst_cfg;
    router_dest_monitor monh;
    router_dest_seqr d_seqr;
    router_dest_driver drvh;
    
    extern function new(string name="router_dest", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    
endclass


function router_dest::new(string name="router_dest", uvm_component parent);
    super.new(name, parent);
endfunction


function void router_dest::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(dest_config)::get(this,"","dest_config",dst_cfg))
        `uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db, have you set() it?")
    monh = router_dest_monitor::type_id::create("monh",this);
    if(dst_cfg.is_active==UVM_ACTIVE)   begin
        drvh = router_dest_driver::type_id::create("drvh",this);
        d_seqr = router_dest_seqr::type_id::create("d_seqh",this);
    end
    
endfunction


function void router_dest::connect_phase(uvm_phase phase);

    if(dst_cfg.is_active == UVM_ACTIVE)  begin
        drvh.seq_item_port.connect(d_seqr.seq_item_export);
    end

endfunction
