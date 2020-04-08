
from workload_generator.utils import translate_matlab_fitting_to_scipy

size_distribution_file = "operation_inter.csv"  # _{}".format('video')
output_distribution_file = "{}_scipy".format(size_distribution_file)
output_stream = file(output_distribution_file, "w")
for fs_line in open(size_distribution_file, "r"):
    request, op1, op2, fitting, parameters = fs_line.split(",")
    fitting, parameters = translate_matlab_fitting_to_scipy(fitting, parameters)
    print >> output_stream, "operation_chain" + "," + request + ","+op1+"," +op2+"," + fitting + "," + parameters


