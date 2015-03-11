#! /usr/bin/env python
import glob
import numpy as np

if __name__ == '__main__':
    fnList = glob.glob('*.png')
    maskPara = np.zeros(len(fnList))
    for i in range(len(fnList)):
        maskPara[i] = float(fnList[i][16:24])
    args = np.argsort(maskPara)
    fnList = np.array(fnList)[args]
    fnList.tofile('fn.dat', sep = '\n')