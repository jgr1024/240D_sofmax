module LPW_pow2 #(
    parameter POW_FW = 15, 
    parameter POW_BW = 16,
    parameter BW = 8, 
    parameter FW = 2
)(
    input [BW-1:0] vec_in,

    output [POW_BW-1:0] vec_out
);

wire [BW-1:FW] int_part;
wire [FW-1:0] frac_part;

wire [BW-1:FW] shift_int;

wire [31:0] LUT_out;
wire [31:0] LUT_inter;

wire [BW-1:0] comp_in;

// Convert to positive
assign comp_in = ~vec_in + 1;

// prepare wires
assign int_part = comp_in[BW-1:FW];
assign frac_part = comp_in[FW-1:0];


pow2_LUT LUT(
    .selector(frac_part),
    .out(LUT_out)
);

assign LUT_inter = LUT_out >> int_part;

assign vec_out = LUT_inter[31:16];


endmodule


