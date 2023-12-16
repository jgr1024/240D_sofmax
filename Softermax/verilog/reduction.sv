module reduction #(
    parameter BW = 16,
    parameter FW = 15,
    parameter OUT_BW = 16,
    parameter OUT_FW = 6,
    parameter VEC_SIZE = 5 
)(
    input wire [BW-1:0] vec_in[VEC_SIZE-1:0],

    output wire [OUT_BW-1:0] vec_out
);

    wire [31:0] tree [2 * VEC_SIZE-1:1];

    genvar i;
    generate
        for(i = 0; i < VEC_SIZE; i++)
        begin : a
            assign tree[i + VEC_SIZE] = {{(32-BW){1'b0}}, vec_in[i]};
        end

        for(i = VEC_SIZE-1; i > 0; i--)
        begin : b
            assign tree[i] = tree[2*i] + tree[2*i+1];
        end
    endgenerate


    assign vec_out = tree[1][24:9];



endmodule

