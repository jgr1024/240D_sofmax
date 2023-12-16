module softermax_tb();

    parameter BW = 8;
    parameter FW = 2;
    parameter POW_BW = 16;
    parameter POW_FW = 6;
    parameter ACCUM_BW = 16;
    parameter ACCUM_FW = 6;
    parameter VEC_SIZE = 10;

    logic [BW-1:0] in[VEC_SIZE-1:0];

    logic [ACCUM_BW-1:0] sum_out;

    logic [31:0] out [VEC_SIZE-1:0];
    logic [BW-1:0] max_out;

    integer file, line, output_file;
    logic [BW-1:0] input_data [VEC_SIZE-1:0];


    bit clk;
    bit rst_n;

    softermax_wrapper #(.VEC_SIZE(VEC_SIZE), .BW(BW), .FW(FW), .POW_BW(POW_BW), .POW_FW(POW_FW), .ACCUM_BW(ACCUM_BW), .ACCUM_FW(ACCUM_FW)) softermax (
        .clk(clk),
        .unnormed_in(in),
        .final_softmax(out)
    );



    initial begin
        //$dumpfile("softermax.vcd");
        //$dumpvars(0, softermax_tb);


        file = $fopen("binary_inps.csv", "r");
        output_file = $fopen("output.txt","w"); 

        while (!$feof(file)) begin
            
            #5;clk = 1'b0;
            line = $fscanf(file, "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h", 
            input_data[0], input_data[1], input_data[2], input_data[3], 
            input_data[4], input_data[5], input_data[6], input_data[7],
            input_data[8], input_data[9]);

            in[0] = input_data[0];
            in[1] = input_data[1];
            in[2] = input_data[2];
            in[3] = input_data[3];
            in[4] = input_data[4];
          
            in[5] = input_data[5];
            in[6] = input_data[6];
            in[7] = input_data[7];
            in[8] = input_data[8];
            in[9] = input_data[9];

            #5;clk = 1'b1;
            $fwrite(output_file,"0x%8h,0x%8h,0x%8h,0x%8h,0x%8h,0x%8h,0x%8h,0x%8h,0x%8h,0x%8h\n", 
            out[0], out[1], out[2], out[3], 
            out[4], out[5], out[6], out[7],
            out[8], out[9]);
            
            

        end
       

        $finish(); 
    end




endmodule
