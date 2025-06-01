
class router_source extends uvm_agent;
    
    `uvm_component_utils(router_source)
    
    source_config src_cfg;
    router_source_monitor monh;
    router_source_seqr s_seqr;
    router_source_driver drvh;
    
    extern function new(string name="router_source", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    
endclass


function router_source::new(string name="router_source", uvm_component parent);
    super.new(name, parent);
endfunction


function void router_source::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(source_config)::get(this,"","source_config",src_cfg))
        `uvm_fatal("CONFIG","cannot get() src_cfg from uvm_config_db, have you set() it?")
    monh = router_source_monitor::type_id::create("monh",this);
    if(src_cfg.is_active==UVM_ACTIVE)   begin
        drvh = router_source_driver::type_id::create("drvh",this);
        s_seqr = router_source_seqr::type_id::create("s_seqh",this);
    end
    
endfunction


function void router_source::connect_phase(uvm_phase phase);

    if(src_cfg.is_active == UVM_ACTIVE)  begin
        drvh.seq_item_port.connect(s_seqr.seq_item_export);
    end

endfunction
