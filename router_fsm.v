module router_fsm (
    input clock, resetn, pkt_valid, fifo_full, fifo_empty_0, fifo_empty_1, fifo_empty_2, parity_done, low_pkt_valid,
    input soft_reset_0, soft_reset_1, soft_reset_2,
    input [1:0] data_in,
    output reg detect_add, ld_state, laf_state, full_state, write_enb_reg, rst_int_reg, busy, lfd_state
);

    parameter DECODE_ADDRESS    = 4'b0000,
              LOAD_FIRST_DATA   = 4'b0001,
              LOAD_DATA         = 4'b0010,
              LOAD_PARITY       = 4'b0011,
              FIFO_FULL_STATE   = 4'b0100,
              LOAD_AFTER_FULL   = 4'b0101,
              WAIT_TILL_EMPTY   = 4'b0110,
              CHECK_PARITY_ERROR = 4'b0111;

    reg [3:0] current_state, next_state;

    always @(posedge clock) begin  //fsm state transition
        if (!resetn)
            current_state <= DECODE_ADDRESS;
        else if (soft_reset_0 || soft_reset_1 || soft_reset_2)
            current_state <= DECODE_ADDRESS;
        else
            current_state <= next_state;
    end

    always @(*) begin
        detect_add = 0;
        ld_state = 0;
        laf_state = 0;
        full_state = 0;
        write_enb_reg = 0;
        rst_int_reg = 0;
        busy = 0;
        lfd_state = 0;
       
        case (current_state)
            DECODE_ADDRESS: begin
                detect_add = 1;
                if (pkt_valid && (data_in[1:0] == 2'b00 && fifo_empty_0) ||
                    (data_in[1:0] == 2'b01 && fifo_empty_1) ||
                    (data_in[1:0] == 2'b10 && fifo_empty_2)) begin
                    next_state = LOAD_FIRST_DATA;
                end else begin
                    next_state = DECODE_ADDRESS;
                end
            end
           
            LOAD_FIRST_DATA: begin
                lfd_state = 1;
                busy = 1;  //keep the header byte latched
                next_state = LOAD_DATA;
            end

            LOAD_DATA: begin
                ld_state = 1;
                busy = 0;
                write_enb_reg = 1;  //active writing mode
                if (!pkt_valid)
                    next_state = LOAD_PARITY;
                else if (fifo_full)
                    next_state = FIFO_FULL_STATE;
                else
                    next_state = LOAD_DATA;
            end

            LOAD_PARITY: begin
                busy = 1;
                write_enb_reg = 1;  //latch the parity byte
                next_state = CHECK_PARITY_ERROR;
            end

            FIFO_FULL_STATE: begin
                busy = 1;
                full_state = 1;
                write_enb_reg = 0;  //stop writing
                next_state = LOAD_AFTER_FULL;
            end

            LOAD_AFTER_FULL: begin
                laf_state = 1;
                busy = 1;
                write_enb_reg = 1;
                if (parity_done)
                    next_state = DECODE_ADDRESS;
                else if (low_pkt_valid)
                    next_state = LOAD_PARITY;
                else
                    next_state = LOAD_DATA;
            end

            WAIT_TILL_EMPTY: begin
                busy = 1;
                write_enb_reg = 0;
                next_state = (fifo_empty_0 || fifo_empty_1 || fifo_empty_2) ? DECODE_ADDRESS : WAIT_TILL_EMPTY;
            end

            CHECK_PARITY_ERROR: begin
                rst_int_reg = 1;
                busy = 1;
                if (!fifo_full)
                    next_state = DECODE_ADDRESS;
                else
                    next_state = FIFO_FULL_STATE;
            end

            default: next_state = DECODE_ADDRESS;
        endcase

/*assign detect_add = (current_state == DECODE_ADDRESS) ? 1'b1 : 1'b0;
assign write_enb_reg = ((current_state == LOAD_DATA) || (current_state == LOAD_AFTER_FULL) || (current_state == LOAD_PARITY)) ? 1'b1 : 1'b0;
assign ld_state = (current_state == LOAD_DATA) ? 1'b1 : 1'b0;
assign lfd_state = (current_state == LOAD_DATA) ? 1'b1 : 1'b0;
assign laf_state = (current_state == LOAD_AFTER_FULL) ? 1'b1 : 1'b0;
assign full_state = (current_state == FIFO_FULL_STATE) ? 1'b1 : 1'b0;
assign rst_int_reg = (current_state == CHECK_PARITY_ERROR) ? 1'b1 : 1'b0;
assign busy = ((current_state == LOAD_FIRST_DATA) || (current_state == FIFO_FULL_STATE) || (current_state == LOAD_AFTER_FULL) || (current_state == LOAD_PARITY) || (current_state == CHECK_PARITY_ERROR) || (current_state == WAIT_TILL_EMPTY)) ? 1'b1 : 1'b0;
*/
end

endmodule
