
class router_dest_monitor extends uvm_monitor;

    `uvm_component_utils(router_dest_monitor)

    virtual router_if vif;
    dest_config dst_cfg;
    dest_xtn txn;
    uvm_tlm_analysis_fifo #(dest_xtn) dmon_ap;

    function new(string name="router_dest_monitor", uvm_component parent);
        super.new(name, parent);
        dmon_ap = new("dmon_ap", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(dest_config)::get(this,"","dest_config",dst_cfg))
            `uvm_fatal("CONFIG","cannot get() dst_cfg from uvm_config_db, habe you set() it?")
        
    endfunction
    
    
    function void connect_phase(uvm_phase phase);
        vif = dst_cfg.vif;
    endfunction
    
    task run_phsse(uvm_phase phase);
        forever
            collect_data();
    endtask
    
    
    
    task collect_data();
        txn=dest_xtn::type_id::create("txn");
        wait(vif.dmon_cb.read_enb == 1)
        
        @(vif.dmon_cb);
        txn.header = vif.dmon_cb.data_out;
        txn.payload = new[txn.header[7:2]];
        
        @(vif.dmon_cb);
        foreach(txn.payload[i])  begin
            txn.payload[i] = vif.dmon_cb.data_out;
            @(vif.dmon_cb);
        end
        
        txn.parity = vif.dmon_cb.data_out;
        
        `uvm_info("DEST_MONITOR", "Displaying the destination monitor data", UVM_MEDIUM)
        txn.print();
        dmon_ap.write(txn);
    endtask
    
endclass
