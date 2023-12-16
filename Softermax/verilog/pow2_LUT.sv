module pow2_LUT(
    input logic [1:0] selector, 
    output logic [31:0] out
);

always_comb 
begin
    // case(selector)
    //     2'b00: out = 'b0;
    //     2'b01: out = 31'b0011000001101111111000001010001;
    //     2'b10: out = 31'b0110101000001001111001100110011;
    //     2'b11: out = 31'b1010111010001001111110011001010;

    //     default: out = 'b0;

    // endcase

    case(selector)
        2'b00: out = 32'b1_0000000000000000000000000000000;
        2'b01: out = 32'b0_1101011101000100111111001100101;
        2'b10: out = 32'b0_1011010100000100111100110011001;
        2'b11: out = 32'b0_1001100000110111111100000101000;

        default: out = 'b0;

    endcase


end

endmodule