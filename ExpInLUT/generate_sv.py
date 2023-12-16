# Necessary imports
from fpbinary import FpBinary, FpBinarySwitchable # To convert from float to fixed
import math # to calculate the e exponential values

# Prompt the user to input the configuration for the SystemVerilog
dataCount = input("Please put in the number of total data points:")
# This is a fixed point implementation, so there will be no exp and mantissa
print("Please indicate the number of bits in the INPUT to Softmax (in signed binary).")
inputIntDigit = int(input("Please indicate the number of digit in the integer part: "))
inputFracDigit = int(input("Please indicate the number of digit in the fractional part: "))
print("Please indicate the number of bits in the LUT/output to Softmax (in unsigned binary).")
LUTIntDigit = int(input("Please indicate the number of digit in the integer part: "))
LUTFracDigit = int(input("Please indicate the number of digit in the fractional part: "))
divCount = input("Please put in the number of iterations in division:")

# TODO: Check the user's input and make sure all numbers are valid

# Variables
IntLUT = [None] * (inputIntDigit - 1)
FracLUT = [None] * inputFracDigit
LUTFile = open("generated_softmax.sv", "w") # Create/Write to the LUT values file
LUTHeaderFile = open("LUT_header.txt", "r") # Read in the header
LUTFooterFile = open("LUT_footer.txt", "r") # Read in the footer

# Complete the Module parameter list with the given input
moduleHeader = "module LUTSoftmaxExp #( DATACOUNT = {in_dataCount}, DIV_ITR_COUNT = {in_divCount}, inputIntDigit = {in_inputIntDigit}, inputFracDigit = {in_inputFracDigit}, LUTIntDigit = {in_LUTIntDigit}, LUTFracDigit = {in_LUTFracDigit}\n"
LUTFile.write(moduleHeader.format(in_dataCount = dataCount, 
                                  in_inputIntDigit = inputIntDigit,
                                  in_inputFracDigit = inputFracDigit,
                                  in_LUTIntDigit = LUTIntDigit,
                                  in_LUTFracDigit = LUTFracDigit,
                                  in_divCount = divCount))

# Write the header contants that is universal
for line in LUTHeaderFile:
    LUTFile.write(line)

# Generate the 2 constants needed to get x0 in DIV
x0_POSconstant_val = 48 / 17
x0_NEGconstant_val = 32 / 17
x0_POSconstant = FpBinary(int_bits=LUTIntDigit, frac_bits=LUTFracDigit, signed=False, value=x0_POSconstant_val)
x0_NEGconstant = FpBinary(int_bits=LUTIntDigit, frac_bits=LUTFracDigit, signed=False, value=x0_NEGconstant_val)
LUTFile.write("\tx0_POSconstant = {bits}\'{LUTbin};\n"
              .format(bits = LUTIntDigit + LUTFracDigit,
                      LUTbin = bin(x0_POSconstant)[1:])) # remove leading 0 in the binary
LUTFile.write("\tx0_NEGconstant = {bits}\'{LUTbin};\n"
              .format(bits = LUTIntDigit + LUTFracDigit,
                      LUTbin = bin(x0_NEGconstant)[1:])) # remove leading 0 in the binary

# Start generating LUT values
# First generate MSB's pos and neg LUT values
# Calculate the exponential value
PosIntLUT_val = math.exp(2 ** (inputIntDigit - 1))
# Convert to fixed point binary
PosIntLUT = FpBinary(int_bits=LUTIntDigit, frac_bits=LUTFracDigit, signed=False, value=PosIntLUT_val)
# print(bin(PosIntLUT)) # Verify the binary
# Calculate the exponential value
NegIntLUT_val = math.exp(-(2 ** (inputIntDigit - 1)))
# Convert to fixed point binary
NegIntLUT = FpBinary(int_bits=LUTIntDigit, frac_bits=LUTFracDigit, signed=False, value=NegIntLUT_val)
# print(bin(PosIntLUT)) # Verify the binary
for LUT_gen_itr in range(inputIntDigit - 1):
    LUT_val = math.exp(2 ** (LUT_gen_itr))
    IntLUT[LUT_gen_itr] = FpBinary(int_bits=LUTIntDigit, frac_bits=LUTFracDigit, signed=False, value=LUT_val)
for LUT_gen_itr in range(inputFracDigit):
    LUT_val = math.exp(2 ** (- LUT_gen_itr - 1))
    FracLUT[LUT_gen_itr] = FpBinary(int_bits=LUTIntDigit, frac_bits=LUTFracDigit, signed=False, value=LUT_val)

# Write computed weights to the file
'''
print("PosIntLUT = {bits}\'{LUTbin};"
              .format(bits = LUTIntDigit + LUTFracDigit,
                      LUTbin = bin(PosIntLUT)[1:])) # remove leading 0 in the binary
'''
LUTFile.write("\tPosIntLUT = {bits}\'{LUTbin};\n"
              .format(bits = LUTIntDigit + LUTFracDigit,
                      LUTbin = bin(PosIntLUT)[1:])) # remove leading 0 in the binary
LUTFile.write("\tNegIntLUT = {bits}\'{LUTbin};\n"
              .format(bits = LUTIntDigit + LUTFracDigit,
                      LUTbin = bin(NegIntLUT)[1:])) # remove leading 0 in the binary
for LUT_gen_itr in range(inputIntDigit - 1):
    LUTFile.write("\tIntLUT[{index}] = {bits}\'{LUTbin};\n"
              .format(bits = LUTIntDigit + LUTFracDigit,
                      LUTbin = bin(IntLUT[LUT_gen_itr])[1:],
                      index = LUT_gen_itr))
for LUT_gen_itr in range(inputFracDigit):
    LUTFile.write("\tFracLUT[{index}] = {bits}\'{LUTbin};\n"
              .format(bits = LUTIntDigit + LUTFracDigit,
                      LUTbin = bin(FracLUT[LUT_gen_itr])[1:],
                      index = LUT_gen_itr))
    
# Write the footer
for line in LUTFooterFile:
    LUTFile.write(line)