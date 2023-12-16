module unnormed_softmax #(
    parameter BW = 8,
    parameter FW = 2,
    parameter POW_BW = 16,
    parameter POW_FW = 15,
    parameter ACCUM_BW = 16,
    parameter ACCUM_FW = 6,
    parameter VEC_SIZE = 4 
)(
    input [BW-1:0] vec_in[VEC_SIZE-1:0],

    output [POW_BW-1:0] vec_out [VEC_SIZE-1:0],
    output [BW-1:0] max_out,
    output [ACCUM_BW-1:0] sum_out
);


    wire [BW-1:0] max_val;

    int_max #(.BW(BW), .FW(FW), .VEC_SIZE(VEC_SIZE)) max_instance(
        .int_max_in(vec_in),
        .max_out(max_val)
    );

    wire [POW_BW-1:0] pow_vals [VEC_SIZE-1:0];
 
    pow2 #( .BW(BW), .VEC_SIZE(VEC_SIZE), .FW(FW), .POW_BW(POW_BW), .POW_FW(POW_FW)) pow_2_unit(
        .vec_in(vec_in),
        .max_in(max_val),
        .pow_out(pow_vals)
    );

    wire [ACCUM_BW-1:0] sum;

    reduction #(.BW(POW_BW), .FW(POW_FW), .OUT_BW(ACCUM_BW), .OUT_FW(ACCUM_FW), .VEC_SIZE(VEC_SIZE)) accum_unit(
        .vec_in(pow_vals),
        .vec_out(sum)
    );

    assign vec_out = pow_vals;
    
    assign sum_out = sum;

    assign max_out = max_val;



endmodule