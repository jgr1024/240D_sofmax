module int_max #(
    parameter BW = 8,
    parameter FW = 2,
    parameter VEC_SIZE = 5 
    )(
    input wire [BW-1:0] int_max_in[VEC_SIZE-1:0],

    output wire [BW-1:0] max_out
);

// Int max unit
wire [BW-1:0] int_max_tree [2 * VEC_SIZE - 1:1];

function [BW-1:0] ciel;
    input [BW-1:0] in_val;
    begin
        if(in_val[FW-1:0] != 0) 
        begin
            ciel = {in_val[BW-1:FW], 2'b00} + {{BW-3{1'b0}},3'b100};
        end
        else
        begin
            ciel = {in_val[BW-1:FW], 2'b00};
        end
    end
endfunction

genvar i;
generate
    for(i = 0; i < VEC_SIZE; i = i + 1) 
    begin : base
        // Convert to integers before sending in tree
        assign int_max_tree[i + VEC_SIZE] = ciel(int_max_in[i]);
    end

    for(i = VEC_SIZE-1; i > 0; i = i - 1)
    begin : rest
        assign int_max_tree[i] = ($signed(int_max_tree[i*2]) < $signed(int_max_tree[i*2 + 1]))? int_max_tree[i*2+1] : int_max_tree[i*2];
    end

endgenerate


assign max_out = int_max_tree[1];

endmodule