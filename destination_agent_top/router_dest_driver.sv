
class router_dest_driver extends uvm_driver #(dest_xtn);
  
    `uvm_component_utils(router_dest_driver)
    
    bit ib0 = 1'b0;
    bit ib1 = 1'b1;

    virtual router_if.DDRV_MP vif;
    dest_config dst_cfg;

    extern function new(string name ="router_dest_driver",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task send_to_dut(dest_xtn req);
      

endclass


function router_dest_driver::new(string name="router_dest_driver", uvm_component parent);
    super.new(name, parent);
endfunction


function void router_dest_driver::build_phase(uvm_phase phase);
    if(!uvm_config_db #(dest_config)::get(this,"","dest_config",dst_cfg))
        `uvm_fatal("DEST_DRIVER","cannot get() dst_cfg from uvm_config_db, have you set() it?")
endfunction


function void router_dest_driver::connect_phase(uvm_phase phase);
    vif = dst_cfg.vif;
endfunction


task router_dest_driver::run_phase(uvm_phase phase);
    forever  begin
        seq_item_port.get_next_item(req);
        send_to_dut(req);
        seq_item_port.item_done();
    end
endtask

task router_dest_driver::send_to_dut(dest_xtn req);
    wait(vif.ddrv_cb.valid_out == 1)
    repeat(req.delay)
    @(vif.ddrv_cb)
    vif.ddrv_cb.read_enb <= ib1;
    @(vif.ddrv_cb)
    wait(vif.ddrv_cb.valid_out == 0)
    @(vif.ddrv_cb)
    vif.ddrv_cb.read_enb <= ib0;
    
    `uvm_info("DEST_DRIVER", "Displaying the destination driver data", UVM_MEDIUM)
    req.print();
endtask
