# Use this script to find the performance of softmax implementations
# Necessary imports
import numpy as np
import functools # Convert hex output to decimal

conv = functools.partial(int, base=16) # Convert hex output to decimal

# Using loadtxt() to load the outputs from the testbench
testbench_output = np.loadtxt("output_from_testbench.txt", delimiter=",", dtype=str, converters=conv)
testbench_output = np.argmax(testbench_output[0:-1],axis=1)


# Load the expected argmax index from targets.csv
expected_output = np.loadtxt("../targets.csv", delimiter=",")
# Convert them to ints for easy comparison
expected_output = (expected_output[:, 1]).astype(int)

# Count the difference
diff_count = np.count_nonzero(testbench_output == expected_output)
diff_percent = (len(expected_output) - diff_count) * 100 / len(expected_output)

# Report the data
print("The number of differences is: " + str(diff_count))
print("The accuracy rate is: " + str(diff_percent) + "%")