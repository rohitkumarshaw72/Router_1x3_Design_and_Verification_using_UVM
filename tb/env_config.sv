
class env_config extends uvm_object;

    bit has_sagent = 1;
    bit has_dagent = 1;
    int no_of_src_agt = 1;
    int no_of_dst_agt = 3;
    bit has_virtual_sequencer = 1;
    bit has_scoreboard;
    
    `uvm_object_utils(env_config)
    
    source_config src_cfg[];
    dest_config dst_cfg [];
    
   
    
    function new(string name= "env_config");
        super.new(name);
    endfunction
    
        
endclass: env_config
