
class router_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(router_scoreboard)
    
    function new(string name="router_scoreboard",uvm_component parent);
        super.new(name,parent);
    endfunction

endclass
