
class router_source_seq extends uvm_sequence #(source_xtn);  

    `uvm_object_utils(router_source_seq)

    extern function new(string name ="router_source_seq");
	
endclass


function router_source_seq::new(string name = "router_source_seq");
    super.new(name);
endfunction



class source_rand_xtn extends router_source_seq;

    `uvm_object_utils(source_rand_xtn)

    extern function new(string name ="source_rand_xtn");
    extern task body();
	
endclass


function source_rand_xtn::new(string name= "source_rand_xtn");
    super.new(name);
endfunction


task source_rand_xtn::body();
    repeat(10)  begin
        req=source_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize());
        finish_item(req);
    end
endtask



class small_packet_seq extends router_source_seq;
    
    `uvm_object_utils(small_packet_seq)
    
    bit [1:0] addr;
    
    extern function new(string name="small_packet_seq");
    extern task body();
    
endclass


function small_packet_seq::new(string name="small_packet_seq");
    super.new(name);
endfunction


task small_packet_seq::body();
    
    req=source_xtn::type_id::create("req");
    if(!uvm_config_db #(bit [1:0])::get(null,get_full_name,"addr",addr))
        `uvm_fatal("CONFIG","cannot get addr from uvm_config_db, have you set() it?")
        
    start_item(req);
    req.randomize() with {
          header[1:0] == addr;
          header[7:2] inside {[1:20]};
    };
    finish_item(req);
    
endtask



class medium_packet_seq extends router_source_seq;
    
    `uvm_object_utils(medium_packet_seq)
    
    bit [1:0] addr;
    
    extern function new(string name="medium_packet_seq");
    extern task body();
    
endclass


function medium_packet_seq::new(string name="medium_packet_seq");
    super.new(name);
endfunction


task medium_packet_seq::body();
    
    req=source_xtn::type_id::create("req");
    if(!uvm_config_db #(bit [1:0])::get(null,get_full_name,"addr",addr))
        `uvm_fatal("CONFIG","cannot get addr from uvm_config_db, have you set() it?")
        
    start_item(req);
    req.randomize() with {
          header[1:0] == addr;
          header[7:2] inside {[21:40]};
    };
    finish_item(req);
    
endtask


class large_packet_seq extends router_source_seq;
    
    `uvm_object_utils(large_packet_seq)
    
    bit [1:0] addr;
    
    extern function new(string name="large_packet_seq");
    extern task body();
    
endclass


function large_packet_seq::new(string name="large_packet_seq");
    super.new(name);
endfunction


task large_packet_seq::body();
    
    req=source_xtn::type_id::create("req");
    if(!uvm_config_db #(bit [1:0])::get(null,get_full_name,"addr",addr))
        `uvm_fatal("CONFIG","cannot get addr from uvm_config_db, have you set() it?")
        
    start_item(req);
    req.randomize() with {
          header[1:0] == addr;
          header[7:2] inside {[41:63]};
    };
    finish_item(req);
    
endtask
