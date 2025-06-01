module router_fifo (
    input clock,
    input resetn,
    input write_enb,
    input soft_reset,
    input read_enb,
    input [7:0] data_in,
    input lfd_state,        // Header byte detection
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);

    parameter DEPTH = 16;
    parameter WIDTH = 9;

    reg [WIDTH-1:0] fifo_mem [DEPTH-1:0];
    reg [3:0] write_ptr, read_ptr;
    reg [4:0] count; //counter to track no. of elements in fifo
    reg [7:0] payload_len; //payload length counter

    always @(posedge clock) begin
        if (!resetn || soft_reset) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
            data_out <= 9'b0;
        end
        else begin
            if (write_enb && !full) begin
                fifo_mem[write_ptr] <= data_in;
                write_ptr <= write_ptr + 1;
                count <= count + 1;
            end
            if (read_enb && !empty) begin
                data_out <= fifo_mem[read_ptr];
                read_ptr <= read_ptr + 1;
                count <= count - 1;

                // Header byte detection
                if (lfd_state) begin
                    payload_len <= fifo_mem[read_ptr][7:0]; //load payload length from header
                end
                else if (payload_len > 0) begin
                    payload_len <= payload_len - 1; //decrement
                end
            end

            full <= (count == DEPTH);
            empty <= (count == 0);

            if (count == 0 || payload_len == 0) begin
                data_out <= 9'bZ;
            end
        end
    end
endmodule