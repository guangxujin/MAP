# -*- coding: utf-8 -*-
'''
Created on 3-10-2020
@author: Guangxu Jin, Wake Forest School of Medicine
@email: guangxujin@gmail.com
'''
import config
from  random import *
import multiprocessing
import time,os,sys

#from utils import *
import numpy as np
from time import sleep
#Automatically choose package for GPU and CPU.
if config.GPU <> "":
    from SF_numba_gpu import *
    from numba import cuda
if config.GPU == "":
    from SF_numba_cpu import *
#cuda.select_device(0)
#from scoop import futures



start = time.time()
print (sys.argv)
config.f=config.data_dir+'/'+sys.argv[1]+'.txt'
config.device_num=sys.argv[2]
print ("processing the job at GPU device ",config.device_num)
cuda.select_device(int(config.device_num))
def main():

  #config.Iter=5
  while 1:
    #load data
    data=load_data()    
    config.N=len(data)
    l=config.N
#   printProgressBar(0, l, prefix = 'Progress:', suffix = 'Complete', length = 100)
#   print "Step 1.3 initializing fitness"
    config.Iter += 1
#        print config.f
    chunks=get_chunks_shuffle(data)
        #print chunks
    print (len(chunks[0]),len(chunks))
    print ('current iteration: ',config.Iter)
    curr_gen = 0
    
    for curr_gen in range (len(chunks)):
        initial_pop()

                a=float(config.factor)
                S_data=np.array(data,dtype=np.float32)
                S_data=a*S_data
                sample_L=range (0,len(S_data))
        config.S_data=S_data[:,1:len(S_data[0,:])]
        config.archive=fitness(config.S_data)

        if True:
            #if write == 0:
              write_archive()
                      
              break
              print ("Step 4 Termination")
        curr_gen += 1
    config.f=config.out_dir+'/'+sys.argv[1]+'/'+str(config.Iter)+'archive.txt'
    if len(chunks) == 1 or config.Iter == 5:
        break
        end = time.time()
        print ('relapse time is ',(end - start))
if __name__ == '__main__':

    main()

