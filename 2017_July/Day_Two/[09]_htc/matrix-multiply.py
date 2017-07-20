#!/usr/bin/env python


import csv
import os
import time
import socket
import sys

import numpy
import numpy.random


MATRIX_SHAPE = (512, 512)


def main():
    for input_file in sys.argv[1:]:
        with open(input_file, 'rb') as fp:
            csv_input = csv.reader(fp)
            for x, y in csv_input:
                x = int(x)
                y = int(y)

                numpy.random.seed(x)
                matrix_x = numpy.random.rand(*MATRIX_SHAPE)
                numpy.random.seed(y)
                matrix_y = numpy.random.rand(*MATRIX_SHAPE)
                matrix_product = numpy.matmul(matrix_x, matrix_y)

                print "{time} (host: {host}, pid: {pid}) matmul(matrix({x}), matrix({y}))".format(
                    host=socket.gethostname(),
                    pid=os.getpid(),
                    time=time.strftime('%H:%M:%S'),
                    x=x,
                    y=y,
                )


if __name__ == '__main__':
    main()
