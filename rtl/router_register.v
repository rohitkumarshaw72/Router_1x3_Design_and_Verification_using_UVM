
module router_register (
    input clock, resetn, pkt_valid, fifo_full, rst_int_reg, detect_add, 
    ld_state, laf_state, full_state, lfd_state,
    input [7:0] data_in,
    output reg parity_done, low_pkt_valid, err,
    output reg [7:0] dout
);
    
    reg [7:0] header_byte;
    reg [7:0] internal_parity;
    reg [7:0] packet_parity;

    always @(posedge clock) begin
        if (!resetn) begin
            dout <= 8'b0;
            err <= 1'b0;
            parity_done <= 1'b0;
            low_pkt_valid <= 1'b0;
            internal_parity <= 8'b0;
            header_byte <= 8'b0;
            packet_parity <= 8'b0;
        end
        
        else begin
            if (detect_add && pkt_valid) begin	//latch header byte
                header_byte <= data_in;
            end
            
            if (lfd_state) begin	//output header byte
                dout <= header_byte;
            end
            
            if (ld_state && !fifo_full) begin	//latch payload byte
                dout <= data_in;
                internal_parity <= internal_parity ^ data_in;
            end
            
            if (ld_state && fifo_full) begin	//latch payload when fifo is full
                packet_parity <= data_in;
            end

            if (laf_state) begin
                dout <= packet_parity;
            end

            if (ld_state && !pkt_valid) begin	//low pkt_valid condition
                low_pkt_valid <= 1'b1;
            end

            if (rst_int_reg) begin
                low_pkt_valid <= 1'b0;
            end
            
            if (ld_state && !fifo_full && !pkt_valid) begin	//parity_done condition
                parity_done <= 1'b1;
            end
            
            if (laf_state && low_pkt_valid && !parity_done) begin
                parity_done <= 1'b1;
            end
            
            if (detect_add) begin
                parity_done <= 1'b0;
            end
            
            if (parity_done) begin
                err <= (internal_parity != packet_parity);
            end
        end
    end
    
endmodule
