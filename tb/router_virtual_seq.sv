class router_virtual_seq extends uvm_sequence #(uvm_sequence_item);

    `uvm_object_utils(router_virtual_seq)
    
    small_packet_seq sseq;
    medium_packet_seq mseq;
    large_packet_seq lseq;
    
    dest_normal_seq dnorm;
    dest_soft_reset_seq dsoft;
    
    router_source_seqr s_seqr[];
    router_dest_seqr d_seqr[];
    router_virtual_seqr v_seqr;
    env_config m_cfg;
    
    extern function new(string name="router_virtual_seq");
    extern task body();

endclass

function router_virtual_seq::new(string name = "router_virtual_seq");
    super.new(name);
endfunction


task router_virtual_seq::body();
    if(!uvm_config_db #(env_config)::get(null,get_full_name(),"m_cfg",m_cfg))
        `uvm_fatal("BODY","cannot get() m_cfg from uvm_config_db")
    s_seqr = new[m_cfg.no_of_src_agt];
    d_seqr = new[m_cfg.no_of_dst_agt];
    
    assert($cast(v_seqr,m_sequencer)) else begin
        `uvm_error("BODY", "Error in $cast of virtual sequencer")
    end
    
    foreach(s_seqr[i])
        s_seqr[i] = v_seqr.s_seqr[i];
    foreach()
        d_seqr[i] = v_seqr.d_seqr[i];
endtask



class small_packet_vseq extends router_virtual_seq;

    `uvm_object_utils(small_packet_vseq)
    
    small_packet_seq sseq;
    dest_normal_seq dnorm;
    dest_soft_reset_seq dsoft;
    
    bit [1:0] addr;
    
    extern function new(string name="small_packet_vseq");
    extern task body();

endclass


function small_packet_vseq::new(string name="small_packet_vseq");
    super.new(name);
endfunction


task small_packet_vseq::body();
    super.body();
    sseq=small_packet_seq::type_id::create("sseq");
    dnorm=dest_normal_seq::type_id::create("dnorm");
    if(!uvm_config_db #(bit [1:0])::get(null,get_full_name,"addr",addr))
        `uvm_fatal("SEQ","cannot get addr from uvm_config_db, have you set() it?")
        
    fork
        sseq.start(s_seqr[0]);
        dnorm.start(d_seqr[addr]);
    join
    
    dsoft=dest_soft_reset_seq::type_id::create("dsoft");
    dsoft.start(d_seqr[addr]);
endtask



class medium_packet_vseq extends router_virtual_seq;

    `uvm_object_utils(medium_packet_vseq)
    
    medium_packet_seq mseq;
    dest_normal_seq dnorm;
    dest_soft_reset_seq dsoft;
    
    bit [1:0] addr;
    
    extern function new(string name="medium_packet_vseq");
    extern task body();

endclass


function medium_packet_vseq::new(string name="medium_packet_vseq");
    super.new(name);
endfunction


task medium_packet_vseq::body();
    super.body();
    mseq=medium_packet_seq::type_id::create("mseq");
    dnorm=dest_normal_seq::type_id::create("dnorm");
    if(!uvm_config_db #(bit [1:0])::get(null,get_full_name,"addr",addr))
        `uvm_fatal("SEQ","cannot get addr from uvm_config_db, have you set() it?")
        
    fork
        mseq.start(s_seqr[0]);
        dnorm.start(d_seqr[addr]);
    join
    
    dsoft=dest_soft_reset_seq::type_id::create("dsoft");
    dsoft.start(d_seqr[addr]);
endtask




class large_packet_vseq extends router_virtual_seq;

    `uvm_object_utils(large_packet_vseq)
    
    large_packet_seq lseq;
    dest_normal_seq dnorm;
    dest_soft_reset_seq dsoft;
    
    bit [1:0] addr;
    
    extern function new(string name="large_packet_vseq");
    extern task body();

endclass


function large_packet_vseq::new(string name="large_packet_vseq");
    super.new(name);
endfunction


task large_packet_vseq::body();
    super.body();
    lseq=large_packet_seq::type_id::create("lseq");
    dnorm=dest_normal_seq::type_id::create("dnorm");
    if(!uvm_config_db #(bit [1:0])::get(null,get_full_name,"addr",addr))
        `uvm_fatal("SEQ","cannot get addr from uvm_config_db, have you set() it?")
        
    fork
        lseq.start(s_seqr[0]);
        dnorm.start(d_seqr[addr]);
    join
    
    dsoft=dest_soft_reset_seq::type_id::create("dsoft");
    dsoft.start(d_seqr[addr]);
endtask

