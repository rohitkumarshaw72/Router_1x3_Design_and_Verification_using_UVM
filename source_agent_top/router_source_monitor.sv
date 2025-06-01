
class router_source_monitor extends uvm_monitor;

    `uvm_component_utils(router_source_monitor)

    virtual router_if vif;
    source_config src_cfg;
    source_xtn txn;
    uvm_tlm_analysis_fifo #(source_xtn) smon_ap;

    function new(string name="router_source_monitor", uvm_component parent);
        super.new(name, parent);
        smon_ap = new("smon_ap", this);
    endfunction
    
    function void build_phase(uvm_phase phase);

        if(!uvm_config_db #(source_config)::get(this,"","source_config",src_cfg))
            `uvm_fatal("SOURCE MONITOR","cannot get() src_cfg from uvm_config_db. have you set() it?")
    
    endfunction


    function void connect_phase(uvm_phase phase);
        vif = src_cfg.vif;
    endfunction


    task run_phase(uvm_phase phase);
        forever begin
            collect_data();
        end
        `uvm_info("ROUTER_SOURCE_MONITOR", "This is source monitor in run", UVM_LOW)
    endtask
    
    task collect_data();
        txn = source_xtn::type_id::create("txn");
        wait(vif.smon_cb.busy == 0)
        wait(vif.smon_cb.pkt_valid == 1)
        txn.header = vif.smon_cb.data_in;
        txn.payload = new[txn.header[7:2]];
        @(vif.smon_cb);
        
        foreach(txn.payload[i])  begin
            wait(vif.smon_cb.busy == 0)
            txn.payload[i] = vif.smon_cb.data_in;
            @(vif.smon_cb);
        end
        wait(vif.smon_cb.pkt_valid == 0)
        txn.parity = vif.smon_cb.data_in;
        @(vif.smon_cb);
        @(vif.smon_cb);
        txn.error = vif.smon_cb.error;
        
        `uvm_info("SOURCE_MONITOR", "Displaying the source monitor data", UVM_MEDIUM)
        txn.print();
        smon_ap.write(txn);
        
    endtask

endclass
