
class dest_xtn extends uvm_sequence_item;

    `uvm_object_utils(dest_xtn)
    
    bit [7:0] header, payload[];
    bit [7:0] parity;
    rand bit [5:0] delay;
    
    function new(string name="dest_xtn");
        super.new(name);
    endfunction
    
    function void do_print(uvm_printer printer);
        super.do_print(printer);
    
        //string name                  bitstream value        size      radix_for_printing
        printer.print_field("header",  this.header,           8,        UVM_HEX);
    
        foreach(payload[i])
            printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_HEX);
        printer.print_field("parity", parity, 8, UVM_HEX);
        
    endfunction
    
endclass
