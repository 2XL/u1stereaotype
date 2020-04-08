
from scipy.stats import stats
import numpy
import math
from scipy.stats import lognorm,genpareto
import json
from workload_generator.utils import get_random_value_from_fitting

# leer del backup sample y representar la grafica.

filename = "operation_inter{}_scipy".format('.csv')

# para cada linea del fichero generar un fichero dat

index_line = 0
for fs_line in open(filename, 'r'):
    # print fs_line
    index_line += 1
    line = fs_line.split(',')
    print index_line, line

    title = line[0]
    profile = line[1]
    op1 = line[2]
    op2 = line[3]
    dist = line[4]
    args = ','.join(line[5:])
    print dist, args

    ob = eval(args)
    file_out_name = "csv/{}_{}_{}.dat".format(profile, op1, op2)
    test = open(file_out_name, "w")
    print file_out_name
    for i in range(1000):
        value = get_random_value_from_fitting(dist, ob)
        # print value
        print >> test, value
    test.close()


print "End read!"