
class router_test extends uvm_test;
    `uvm_component_utils(router_test)

    router_env env;
    env_config m_cfg;
    source_config src_cfg[];
    dest_config dst_cfg[];
    
    int no_of_src_agt = 1;
    int no_of_dst_agt = 3;

    function new(string name="router_test", uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void config_router();
        begin
            src_cfg = new[no_of_src_agt];
            foreach(src_cfg[i])  begin
                src_cfg[i] = source_config::type_id::create($sformatf("src_cfg[%0d]",i));
                
                if(!uvm_config_db #(virtual router_if)::get(this,"","vif",src_cfg[i].vif))
                    `uvm_fatal("VIF CONFIG - SOURCE","cannot get() vif from uvm_config_db, have you set() it?")
                    
                src_cfg[i].is_active = UVM_ACTIVE;
                m_cfg.src_cfg[i] = src_cfg[i];
            end
        end
        
        begin
            dst_cfg = new[no_of_dst_agt];
            foreach(dst_cfg[i])  begin
                dst_cfg[i] = dest_config::type_id::create($sformatf("dst_cfg[%0d]",i));
                
                if(!uvm_config_db #(virtual router_if)::get(this,"*",$sformatf("vif_%0d",i),dst_cfg[i].vif))
                    `uvm_fatal("VIF CONFIG - DESTINATION","cannot get() vif from uvm_config_db, have you set() it?")
                    
                dst_cfg[i].is_active = UVM_ACTIVE;
                m_cfg.dst_cfg[i] = dst_cfg[i];
            end
        end
        
        m_cfg.no_of_src_agt = no_of_src_agt;
        m_cfg.no_of_dst_agt = no_of_dst_agt;
        
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        m_cfg=env_config::type_id::create("m_cfg");
        if(m_cfg.has_sagent)  begin
            m_cfg.src_cfg = new[no_of_src_agt];
        end
        
        if(m_cfg.has_dagent)  begin
            m_cfg.dst_cfg = new[no_of_dst_agt];
        end
        config_router();
        uvm_config_db #(env_config)::set(this,"*","env_config",m_cfg);
        env = router_env::type_id::create("env", this);
    endfunction

endclass


class router_random_test extends router_test;
    
    `uvm_component_utils(router_random_test)
    
    //source_rand_xtn src_seqh;
    //dest_rand_xtn dst_seqh;
    //bit [1:0] addr;
    
    extern function new(string name = "router_random_test" , uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void end_of_elaboration_phase(uvm_phase phase);
    //extern task run_phase(uvm_phase phase);
    
endclass

function router_random_test::new(string name = "router_random_test" , uvm_component parent);
    super.new(name, parent);
endfunction

function void router_random_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

function void router_random_test::end_of_elaboration_phase(uvm_phase phase);
        
    super.end_of_elaboration_phase(phase);
    `uvm_info("TEST", "Printing UVM topology", UVM_MEDIUM)
    uvm_top.print_topology();
    
endfunction


/*task router_random_test::run_phase(uvm_phase phase);

    addr = $random % 3;
    uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);
    
    phase.raise_objection(this);
    src_seqh = source_rand_xtn::type_id::create("src_seqh"); 
    src_seqh.start(env.src_agt_top.agth[0].s_seqr);
    dst_seqh = dest_rand_xtn::type_id::create("dst_seqh"); 
    dst_seqh.start(env.dst_agt_top.agth[addr].d_seqr);
    phase.drop_objection(this);
    
endtask*/



class small_packet_test extends router_test;

    `uvm_component_utils(small_packet_test)
    
    bit [1:0] addr;
    
    small_packet_seq sseq;
    dest_normal_seq dnorm;
    dest_soft_reset_seq dsoft;
        
    extern function new(string name="small_packet_test",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass


function small_packet_test::new(string name="small_packet_test",uvm_component parent);
    super.new(name,parent);
endfunction


function void small_packet_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


task small_packet_test::run_phase(uvm_phase phase);
    sseq = small_packet_seq::type_id::create("sseq");
    dnorm = dest_normal_seq::type_id::create("dnorm");
    dsoft=dest_soft_reset_seq::type_id::create("dsoft");
    addr = $random % 3;
    uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);
    phase.raise_objection(this);
    
    fork
        sseq.start(env.src_agt_top.agth[0].s_seqr);
        dnorm.start(env.dst_agt_top.agth[addr].d_seqr);
    join

    dsoft.start(env.dst_agt_top.agth[addr].d_seqr);
    
    phase.drop_objection(this);

endtask



class medium_packet_test extends router_test;

    `uvm_component_utils(medium_packet_test)
    
    bit [1:0] addr;
    
    medium_packet_seq mseq;
    
    extern function new(string name="medium_packet_test",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass


function medium_packet_test::new(string name="medium_packet_test",uvm_component parent);
    super.new(name,parent);
endfunction


function void medium_packet_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


task medium_packet_test::run_phase(uvm_phase phase);
    mseq = medium_packet_seq::type_id::create("mseq");
    addr = $random % 3;
    uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);
    phase.raise_objection(this);
    mseq.start(env.src_agt_top.agth[0].s_seqr);
    phase.drop_objection(this);
endtask



class large_packet_test extends router_test;

    `uvm_component_utils(large_packet_test)
    
    bit [1:0] addr;
    
    large_packet_seq lseq;
    
    extern function new(string name="large_packet_test",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

endclass


function large_packet_test::new(string name="large_packet_test",uvm_component parent);
    super.new(name,parent);
endfunction


function void large_packet_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


task large_packet_test::run_phase(uvm_phase phase);
    lseq = large_packet_seq::type_id::create("lseq");
    addr = $random % 3;
    uvm_config_db #(bit [1:0])::set(this,"*","addr",addr);
    phase.raise_objection(this);
    lseq.start(env.src_agt_top.agth[0].s_seqr);
    phase.drop_objection(this);
endtask

