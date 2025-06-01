
class router_dest_seq extends uvm_sequence #(dest_xtn);  

    `uvm_object_utils(router_dest_seq)

    extern function new(string name ="router_dest_seq");
	
endclass


function router_dest_seq::new(string name = "router_dest_seq");
    super.new(name);
endfunction



class dest_rand_xtn extends router_dest_seq;

    `uvm_object_utils(dest_rand_xtn)

    extern function new(string name ="dest_rand_xtn");
    extern task body();
	
endclass


function dest_rand_xtn::new(string name= "dest_rand_xtn");
    super.new(name);
endfunction


task dest_rand_xtn::body();
    repeat(10)  begin
        req=dest_xtn::type_id::create("req");
        start_item(req);
        assert(req.randomize());
        finish_item(req);
    end
endtask




class dest_normal_seq extends router_dest_seq;

    `uvm_object_utils(dest_normal_seq)

    extern function new(string name ="dest_normal_seq");
    extern task body();
	
endclass


function dest_normal_seq::new(string name= "dest_normal_seq");
    super.new(name);
endfunction


task dest_normal_seq::body();
    repeat(10)  begin
        req=dest_xtn::type_id::create("req");
        start_item(req);
        req.randomize() with {  delay < 30;  };
        finish_item(req);
    end
endtask



class dest_soft_reset_seq extends router_dest_seq;

    `uvm_object_utils(dest_soft_reset_seq)

    extern function new(string name ="dest_soft_reset_seq");
    extern task body();
	
endclass


function dest_soft_reset_seq::new(string name= "dest_soft_reset_seq");
    super.new(name);
endfunction


task dest_soft_reset_seq::body();
    repeat(10)  begin
        req=dest_xtn::type_id::create("req");
        start_item(req);
        req.randomize() with {  delay > 30;  };
        finish_item(req);
    end
endtask

