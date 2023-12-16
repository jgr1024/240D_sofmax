module norm #(
    parameter BW = 8,
    parameter ACCUM_BW = 16,
    parameter ACCUM_FW = 6,
    parameter VEC_SIZE = 10
)(
    input [ACCUM_BW-1:0] vec_in[VEC_SIZE-1:0],
    

    input [ACCUM_BW-1:0] denom_in,

    input [BW-1:0] max,

    output [31:0] vec_out[VEC_SIZE-1:0]
);


logic [3:0] sel_wire;
assign sel_wire = denom_in[ACCUM_FW+3:ACCUM_FW];


wire [15:0] m_val;
wire [31:0] c_val;

wire [31:0] reciep_val_mult;
wire [31:0] reciep_val;


reciep_MLUT MLUT(
    .selector(sel_wire),
    .value(m_val)
);

reciep_CLUT CLUT(
    .selector(sel_wire),
    .value(c_val)
);

assign reciep_val_mult = m_val *  denom_in;

assign reciep_val = reciep_val_mult + c_val;


wire [31:0] div_out [VEC_SIZE-1:0];

genvar i;
generate
    for(i = 0; i < VEC_SIZE; i++) 
    begin : a
        assign div_out[i] = vec_in[i] * reciep_val;
    end
endgenerate

generate
    for(i = 0; i < VEC_SIZE; i++) 
    begin : p
        assign vec_out[i] = div_out[i];
    end
endgenerate

endmodule


