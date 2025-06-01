
interface router_if(input bit clock);
    logic [7:0] data_in, data_out;
    logic pkt_valid, resetn, error, busy, read_enb, valid_out;
    
    clocking sdrv_cb@(posedge clock);
        output resetn, pkt_valid, data_in;
        input busy;
    endclocking
    
    clocking smon_cb@(posedge clock);
        input pkt_valid, busy, error, resetn, data_in;
    endclocking
    
    clocking ddrv_cb@(posedge clock);
        input valid_out;
        output read_enb;
    endclocking
    
    clocking dmon_cb@(posedge clock);
        input data_out, read_enb, valid_out;
    endclocking
    
    modport SDRV_MP (clocking sdrv_cb);
    modport SMON_MP (clocking smon_cb);
    modport DDRV_MP (clocking ddrv_cb);
    modport DMON_MP (clocking dmon_cb);
    
endinterface
