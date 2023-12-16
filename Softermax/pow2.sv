module pow2 #(
    parameter BW = 8,
    parameter VEC_SIZE = 5, 
    parameter FW = 2,
    parameter POW_BW = 16,
    parameter POW_FW = 15
)(
    input [BW-1:0] vec_in [VEC_SIZE-1:0],
    
    input [BW-1:0] max_in,

    output [POW_BW-1:0] pow_out [VEC_SIZE-1:0]
);

wire [BW-1:0] normed_in [VEC_SIZE-1:0];

genvar i;
generate
    for(i = 0; i < VEC_SIZE; i++)
    begin : c 
        assign normed_in[i] = vec_in[i] - max_in; 
    end
endgenerate


generate
    for (i = 0; i < VEC_SIZE; i++) 
    begin : pow_gen
        LPW_pow2 #(.BW(BW), .FW(FW), .POW_BW(POW_BW), .POW_FW(POW_FW)) power_linear (
            .vec_in(normed_in[i]),
            .vec_out(pow_out[i])
        );
    end
endgenerate


endmodule

