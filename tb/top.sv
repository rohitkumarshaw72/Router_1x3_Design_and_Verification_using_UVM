
module top;

    import uvm_pkg::*;
    
    import router_pkg::*;
    
    bit clock;
    
    always 
    #5 clock = ~clock;
    
    router_if in(clock);
    router_if in0(clock);
    router_if in1(clock);
    router_if in2(clock);
    
    router_top DUV(.clock(clock),
                  .resetn(in.resetn),
                  .pkt_valid(in.pkt_valid),
                  .data_in(in.data_in),
                  .err(in.error),
                  .busy(in.busy),
                  .read_enb_0(in0.read_enb),
                  .vld_out_0(in0.valid_out),
                  .data_out_0(in0.data_out),
                  .read_enb_1(in1.read_enb),
                  .vld_out_1(in1.valid_out),
                  .data_out_1(in1.data_out),
                  .read_enb_2(in2.read_enb),
                  .vld_out_2(in2.valid_out),
                  .data_out_2(in2.data_out)
    );
    
    initial begin
        //set the interface instances as strings vif_0, vif_1, vif_2, vif_3 using the uvm_config_db and then call run_test()
        
        `ifdef VCS
         $fsdbDumpvars(0, top);
        `endif
        
        uvm_config_db #(virtual router_if)::set(null,"*","vif",in);
        uvm_config_db #(virtual router_if)::set(null,"*","vif_0",in0);
        uvm_config_db #(virtual router_if)::set(null,"*","vif_1",in1);
        uvm_config_db #(virtual router_if)::set(null,"*","vif_2",in2);
        
        run_test();
    end                  

endmodule
