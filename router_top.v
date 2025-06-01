
module router_top (
    input clock,
    input resetn,
    input [7:0] data_in,
    input pkt_valid,
    input read_enb_0, read_enb_1, read_enb_2,
    output [7:0] data_out_0, data_out_1, data_out_2,
    output vld_out_0, vld_out_1, vld_out_2,
    output err, busy
);

    wire [2:0] write_enb;
    wire [7:0] dout;
    
    router_register reg1  (
        .clock(clock),
        .resetn(resetn),
        .pkt_valid(pkt_valid),
        .data_in(data_in),
        .fifo_full(fifo_full),
        .rst_int_reg(rst_int_reg),
        .detect_add(detect_add),
        .ld_state(ld_state),
        .full_state(full_state),
        .lfd_state(lfd_state),
        .parity_done(parity_done),
        .low_pkt_valid(low_pkt_valid),
        .dout (dout),
        .err(err)
    );
    
    router_fsm fsm1  (
        .clock(clock),
        .busy (busy),
        .resetn(resetn),
        .pkt_valid(pkt_valid),
        .fifo_empty_0(empty_0),
        .fifo_empty_1(empty_1),
        .fifo_empty_2(empty_2),
        .fifo_full(fifo_full),
        .detect_add(detect_add),
        .ld_state(ld_state),
        .laf_state(laf_state),
        .full_state(full_state),
        .lfd_state(lfd_state),
        .write_enb_reg(write_enb_reg),
        .rst_int_reg(rst_int_reg),
        .parity_done(parity_done),
        .low_pkt_valid(low_pkt_valid),
        .soft_reset_0 (soft_reset_0),
        .soft_reset_1 (soft_reset_1),
        .soft_reset_2 (soft_reset_2),
        .data_in (data_in [1:0])
    );
    
    router_synchronizer sync1  (
        .clock(clock),
        .resetn(resetn),
        .data_in(data_in[1:0]),
        .detect_add(detect_add),
        .write_enb_reg(write_enb_reg),
        .full_0(full_0),
        .full_1(full_1),
        .full_2(full_2),
        .write_enb(write_enb),
        .empty_0 (empty_0),
        .empty_1 (empty_1),
        .empty_2 (empty_2),
        .fifo_full (fifo_full),
        .vld_out_0 (vld_out_0),
        .vld_out_1 (vld_out_1),
        .vld_out_2 (vld_out_2),
        .soft_reset_0 (soft_reset_0),
        .soft_reset_1 (soft_reset_1),
        .soft_reset_2 (soft_reset_2),
        .read_enb_0 (read_enb_0),
        .read_enb_1 (read_enb_1),
        .read_enb_2 (read_enb_2)
    );
    
    router_fifo fifo0  (
        .clock(clock),
        .resetn(resetn),
        .write_enb(write_enb[0]),
        .read_enb(read_enb_0),
        .soft_reset(soft_reset_0),
        .data_in(dout),
        .data_out(data_out_0),
        .empty(empty_0),
        .full(full_0),
        .lfd_state(lfd_state)
    );
    
    router_fifo fifo1  (
        .clock(clock),
        .resetn(resetn),
        .write_enb(write_enb[1]),
        .read_enb(read_enb_1),
        .soft_reset(soft_reset_1),
        .data_in(dout),
        .data_out(data_out_1),
        .empty(empty_1),
        .full(full_1),
        .lfd_state(lfd_state)
    );
    
    router_fifo fifo2  (
        .clock(clock),
        .resetn(resetn),
        .write_enb(write_enb[2]),
        .read_enb(read_enb_2),
        .soft_reset(soft_reset_2),
        .data_in(dout),
        .data_out(data_out_2),
        .empty(empty_2),
        .full(full_2),
        .lfd_state(lfd_state)
    );

endmodule
