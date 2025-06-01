
class dest_config extends uvm_object;
    `uvm_object_utils(dest_config)
    
    virtual router_if vif;
    
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    
    extern function new(string name = "dest_config");
    
endclass: dest_config


function dest_config::new(string name = "dest_config");
    super.new(name);
endfunction
