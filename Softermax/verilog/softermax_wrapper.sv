module softermax_wrapper #(
    parameter BW = 8,
    parameter FW = 2,
    parameter POW_BW = 16,
    parameter POW_FW = 6,
    parameter ACCUM_BW = 16,
    parameter ACCUM_FW = 6,
    parameter VEC_SIZE = 10
)(
	 input clk,
    input [BW-1:0] unnormed_in [VEC_SIZE-1:0],

    output [31:0] final_softmax [VEC_SIZE-1:0]
);


    logic [ACCUM_BW-1:0] sum_out;
    logic [POW_BW-1:0] pow_out [VEC_SIZE-1:0];
    logic [BW-1:0] max_out;
	 
	 logic [ACCUM_BW-1:0] sum_out_q;
    logic [POW_BW-1:0] pow_out_q [VEC_SIZE-1:0];
    logic [BW-1:0] max_out_q;


    logic [31:0] soft_out [VEC_SIZE-1:0];
	 logic [31:0] soft_out_q [VEC_SIZE-1:0];
	 
	 logic [BW-1:0] unnormed_in_q [VEC_SIZE-1:0];
	 
	 always_ff @(posedge clk)
	 begin
		unnormed_in_q <= unnormed_in;
		sum_out_q <= sum_out;
      pow_out_q <= pow_out;
      max_out_q <= max_out;
		soft_out_q <= soft_out;
	 end

    unnormed_softmax #(.VEC_SIZE(VEC_SIZE), .BW(BW), .FW(FW), .POW_BW(POW_BW), .POW_FW(POW_FW), .ACCUM_BW(ACCUM_BW), .ACCUM_FW(ACCUM_FW)) unnormed_instance(
        .vec_in(unnormed_in_q),
        .vec_out(pow_out),
        .sum_out(sum_out),
        .max_out(max_out)
    );
	 

    norm #(.VEC_SIZE(VEC_SIZE), .BW(BW), .ACCUM_BW(ACCUM_BW), .ACCUM_FW(ACCUM_FW)) norm_unit(
        .vec_in(pow_out_q),
        .denom_in(sum_out_q),
        .max(max_out_q),
        .vec_out(soft_out)
    );
    
    assign final_softmax = soft_out_q;


endmodule