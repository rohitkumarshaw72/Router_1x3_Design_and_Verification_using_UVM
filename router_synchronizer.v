module router_synchronizer (
    input clock, input resetn,
    input [1:0] data_in, input write_enb_reg, input detect_add,
    input empty_0, input empty_1, input empty_2,
    input full_0, input full_1, input full_2,
    
    input read_enb_0, input read_enb_1, input read_enb_2,
    output reg fifo_full,
    output reg vld_out_0, output reg vld_out_1, output reg vld_out_2,
    output reg [2:0] write_enb,
    output reg soft_reset_0, output reg soft_reset_1, output reg soft_reset_2
);

    // Internal counters for soft reset
    reg [4:0] count_0, count_1, count_2; reg [2:0] temp;
    
    // Write enable generation based on the write_enb_reg, detect_add, and data_in
    always @ (*) begin
        if (~resetn)
            temp <= 2'b0;
            // write_enb <= 3'b000;
            
        else if (detect_add == 1'b1)
            temp <= data_in;
            
        else
            temp <= temp;
            
    end
    
    // FIFO full detection based on data_in and full status of the FIFOs
    always @ (*) begin
        if (write_enb_reg) begin
            case (data_in)
                2'b00: write_enb <= 3'b001;  //writing to FIFO 0
                2'b01: write_enb <= 3'b010;  //writing to FIFO 1
                2'b10: write_enb <= 3'b100;  //writing to FIFO 2
                default: write_enb <= 3'b000;
            endcase
        end
        
        else
            write_enb <= 3'b000;
    end
    
    always @ (*) begin
        case (data_in)
            2'b00: fifo_full <= full_0;
            2'b01: fifo_full <= full_1;
            2'b10: fifo_full <= full_2;
            default: fifo_full <= 0;
        endcase
    end
    
    // Valid output signal generation based on empty status of FIFOs
    always @ (posedge clock) begin
        if (!resetn) begin
            assign vld_out_0 = 0;
            assign vld_out_1 = 0;
            assign vld_out_2 = 0;
        end
        
        else begin
            assign vld_out_0 = ~empty_0;
            assign vld_out_1 = ~empty_1;
            assign vld_out_2 = ~empty_2;
        end
    end
    
    // Soft reset logic based on 30 clock cycle timeouts for each FIFO
    always @ (posedge clock) begin
        if (!resetn) begin
            soft_reset_0 <= 0;
            soft_reset_1 <= 0;
            soft_reset_2 <= 0;
            count_0 <= 0;
            count_1 <= 0;
            count_2 <= 0;
        end
        
        else begin
            // For FIFO 0
            if(vld_out_0 && !read_enb_0) begin
                count_0 <= count_0 + 1;
                if (count_0 == 30)
                    soft_reset_0 <= 1;
            end
            
            else begin
                count_0 <= 0;
                soft_reset_0 <= 0;
            end
            
            // For FIFO 1
            if(vld_out_1 && !read_enb_1) begin
                count_1 <= count_1 + 1;
                if (count_1 == 30)
                    soft_reset_1 <= 1;
            end
            
            else begin
                count_1 <= 0;
                soft_reset_1 <= 0;
            end
            
            // For FIFO 2
            if (vld_out_2 && !read_enb_2) begin
                count_2 <= count_2 + 1;
                if (count_2 == 30)
                    soft_reset_2 <= 1;
            end
            
            else begin
                count_2 <= 0;
                soft_reset_2 <= 0;
            end
        end
    end
    
endmodule
