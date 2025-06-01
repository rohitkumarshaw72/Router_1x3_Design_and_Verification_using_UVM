
class router_source_driver extends uvm_driver #(source_xtn);

    bit ib0 = 1'b0;
    bit ib1 = 1'b1;
  
    `uvm_component_utils(router_source_driver)

    virtual router_if.SDRV_MP vif;
    source_config src_cfg;

    extern function new(string name ="router_source_driver",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task send_to_dut(source_xtn xtn);  

endclass


function router_source_driver::new(string name="router_source_driver", uvm_component parent);
    super.new(name, parent);
endfunction

function void router_source_driver::build_phase(uvm_phase phase);

    if(!uvm_config_db #(source_config)::get(this,"","source_config",src_cfg))
        `uvm_fatal("SOURCE DRIVER","cannot get() src_cfg from uvm_config_db. have you set() it?")
    

endfunction


function void router_source_driver::connect_phase(uvm_phase phase);
    vif = src_cfg.vif;
endfunction


task router_source_driver::run_phase(uvm_phase phase);
    
    @(vif.sdrv_cb);
        vif.sdrv_cb.resetn <= ib0;
    @(vif.sdrv_cb);
        vif.sdrv_cb.resetn <= ib1;
        
    
    forever  begin
        seq_item_port.get_next_item(req);
        send_to_dut(req);
        seq_item_port.item_done();
    end
endtask

task router_source_driver::send_to_dut(source_xtn xtn);
    
    wait(vif.sdrv_cb.busy == 0)
        vif.sdrv_cb.pkt_valid <= ib1;
        vif.sdrv_cb.data_in <= req.header;
        @(vif.sdrv_cb);
        foreach(req.payload[i])  begin
            wait(vif.sdrv_cb.busy == 0)
            vif.sdrv_cb.data_in <= req.payload[i];
            @(vif.sdrv_cb);    
        end
        
        vif.sdrv_cb.pkt_valid <= ib0;
        vif.sdrv_cb.data_in <= req.parity;
    
    `uvm_info("SOURCE_DRIVER", "Displaying the source driver data", UVM_MEDIUM)
    
    xtn.print();
endtask
