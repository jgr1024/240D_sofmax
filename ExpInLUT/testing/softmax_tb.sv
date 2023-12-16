module softmax_tb();

    // Parameter needed to instantiate module
    parameter DATACOUNT = 10;
    parameter DIV_ITR_COUNT = 5;
    parameter inputIntDigit = 6;
    parameter inputFracDigit = 2;
    parameter LUTIntDigit = 4;
    parameter LUTFracDigit = 12;

    // input & output for the instantiated softmax module
    logic [inputIntDigit + inputFracDigit - 1:0] input_data[DATACOUNT];
    logic [LUTIntDigit + LUTFracDigit - 1:0] output_data[DATACOUNT];

    // clock and reset signals (not needed for this one)
    bit clk;
    bit rst_n;

    // Instantiate module
    LUTSoftmaxExp #(.DATACOUNT(DATACOUNT), 
                    .DIV_ITR_COUNT(DIV_ITR_COUNT), 
                    .inputIntDigit(inputIntDigit), 
                    .inputFracDigit(inputFracDigit), 
                    .LUTIntDigit(LUTIntDigit), 
                    .LUTFracDigit(LUTFracDigit)) LUTSoftmaxExp_instance(
        .softmaxInput(input_data),
        .softmaxOutput(output_data)
    );

    // Iterate through all values inthe .csv files
    // Currently testing with 10 inputs at the same time
    initial begin
        // Read the csv values from the file
        integer file, count, output_file;
        file = $fopen("binary_inps.csv", "r");
        output_file = $fopen("output_from_testbench.txt","w");
        while (!$feof(file)) begin
            #5ns count = $fscanf(file, "%h,%h,%h,%h,%h,%h,%h,%h,%h,%h", 
                input_data[0], input_data[1], input_data[2], input_data[3], 
                input_data[4], input_data[5], input_data[6], input_data[7],
                input_data[8], input_data[9]);
            #5ns $fwrite(output_file,"%h,%h,%h,%h,%h,%h,%h,%h,%h,%h\n", 
                output_data[0], output_data[1], output_data[2], output_data[3], 
                output_data[4], output_data[5], output_data[6], output_data[7],
                output_data[8], output_data[9]);
        end
        // Close the read file
        $fclose(file);
        $finish(); 
    end

    // Use a clock signal
    always begin			           	  // tick ... tock 
        #5ns clk = 'b1;
        #5ns clk = 'b0;
    end

endmodule