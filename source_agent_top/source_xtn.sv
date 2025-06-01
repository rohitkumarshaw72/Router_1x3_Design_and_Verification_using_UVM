
class source_xtn extends uvm_sequence_item;

    `uvm_object_utils(source_xtn)
    
    bit resetn, pkt_valid, error, busy;
    rand bit [7:0] header, payload[];
    bit [7:0] parity;
    
    constraint C1 {header[1:0] != 3;}
    constraint C2 {payload.size == header[7:2];}
    constraint C3 {header[7:2] != 0;}
    
    extern function new(string name="source_xtn");
    extern function void post_randomize();
    extern function void do_print(uvm_printer printer);

endclass: source_xtn



function source_xtn::new(string name="source_xtn");
    super.new(name);
endfunction


function void source_xtn::do_print(uvm_printer printer);
    super.do_print(printer);
    
    //string name                  bitstream value        size      radix_for_printing
    printer.print_field("header",  this.header,           8,        UVM_HEX);
    
    foreach(payload[i])
        printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_HEX);
    printer.print_field("parity", parity, 8, UVM_HEX);
    printer.print_field("error", this.error, 8, UVM_HEX);
    printer.print_field("busy", this.busy, 8, UVM_HEX);
endfunction


function void source_xtn::post_randomize();
    parity=0 ^ header;
    foreach(payload[i])  begin
        parity = payload[i] ^ parity;
    end
endfunction


class bad_xtn extends source_xtn;

    `uvm_object_utils(bad_xtn)
    
    //rand xtn_type trans_type;
    
    extern function new(string name="bad_xtn");
    extern function void post_randomize();
    extern function void do_print(uvm_printer printer);

endclass


function bad_xtn::new(string name="bad_xtn");
    super.new(name);
endfunction


function void bad_xtn::post_randomize();

endfunction


function void bad_xtn::do_print(uvm_printer printer);

endfunction
