
class router_source_seqr extends uvm_sequencer #(source_xtn);

    `uvm_component_utils(router_source_seqr)

    function new(string name="router_source_seqr", uvm_component parent);
        super.new(name, parent);
    endfunction
  
endclass
