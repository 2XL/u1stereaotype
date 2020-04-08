
import collections

# read first file

file_one = "operation_inter.csv_scipy"

# read second file [with freq]

file_two = "operation_inter_scipy_freq.csv"

lista = dict()

with open(file_one) as f:
    for line in f:
        key = ','.join(line.split(',')[0:4])
        value = ','.join(line.split(',')[4:])
        lista[key] = value
        print key

with open(file_two) as f:
    for line in f:
        key = ','.join(line.split(',')[0:4])
        value = line.split(',')[4]
        lista[key] = "{},{},{}".format(key, value, lista[key])
        # print lista[key]

output_distribution_file = "inter_operation_join_freq.csv"
output_stream = file(output_distribution_file, "w")
for key in sorted(lista):
    print >> output_stream, lista[key].rstrip()
