# -*- coding: utf-8 -*-
import random,os
import config
import subprocess
from random import shuffle
import numpy as np
import time
import ReadFile
import math
####GPU speed-up by numba
#cuda.select_device(config.device_num)
#@vectorize(['float32(float32, float32)'], target='cuda')
#@autojit
def dominated(a, b):
  #print a,b
  #print np.greater(a,b)
  return np.greater_equal(a,b)
#@autojit
def equal(a, b):
  #print np.equal(a,b)
  return np.not_equal(a,b)
#@autojit
def total(a,b,dim):
#  print a
 # print np.sum(a,axis=1)
  return np.where((np.count_nonzero(a,axis=1) >= dim) & (np.count_nonzero(b,axis=1) >0))

#@vectorize(['float32(float32,float32)'], target='cuda')
#@autojit
def nondominated(a, b):
    return np.greater_equal(b,a)
#@autojit
def total_ND(a,b,L,dim):
 # print np.sum(L,axis=0)
  #return L[np.where(np.sum(a,axis=1) == dim)[0].tolist()]
#  print np.count_nonzero(a,axis=1),dim,np.where(np.count_nonzero(a,axis=1) == dim)
  return L[np.where((np.count_nonzero(a,axis=1) >= dim) & (np.count_nonzero(b,axis=1) >0))[0],:]

# Initialize arrays
#@autojit
def dist(a,b):
  return min(np.linalg.norm(b-a,axis=1))

#@autojit
def dist_all(a,b):
    return np.linalg.norm(b-a,axis=1)
  
#@autojit
def dist_m(a,b):
    return np.mean(np.linalg.norm(b-a,axis=1),axis=0)
def fitness(M):
  #print M[0:1]
#  M=np.array(np.random.rand(10000,11),dtype=np.float32)
  dim=int(math.ceil(float(len(M[0,:]))*0.8
  sc= len(M[:,0])
  print (sc)
  #print dim,sc
  #print M
  A = np.array(M,dtype=np.float32)
  B =np.array(M,dtype=np.float32)
  C = np.empty_like(A, dtype=np.float32)
  D = np.empty_like(A, dtype=np.float32)
  start=time.time()
  #print A[1,:],B[0:2,:]

  L=np.empty_like(np.random.rand(sc,1), dtype=A.dtype)
  #L=[]
  print "calculating Strenghth:"
  for k in range (len(A)):
          C = dominated(A[k,:], B)
          D = equal(A[k,:],B)
    #      print C
          S = total(C,D,dim)[0].size
   #       print 'strength value:',S
       #   print M,B
          #L[k,0]=k
          L[k,0]=S
   #       L.append(S)
   #       print B
   #       print k,S
          if k %1 ==0:
    #        print k
            #print 'strength:',L
#            print
            printProgressBar(k+1, len(A), prefix = 'Progress:', suffix = 'Complete', length = 60)
  #print L
  F=np.empty_like(np.random.rand(sc,5), dtype=A.dtype)
#  F=[]
 
  #  print 'empty F:',F
  print ("calculating Fitness:")
  num=0
  for k in range (len(A)):
       C = nondominated(A[k,:], B)
       D = equal(A[k,:],B)
  #     print C
       S = total_ND(C,D,L,dim)
 #      print S
#       print np.sum(S[:,0],axis =0)
       
       F[k,0]=float(np.sum(S[:,0],axis =0))/float(len(A)+1)

       Dis = total_ND(C,D,B,dim)
       d=0
       dm=0
       if F[k,0] > 0:
         d=dist(A[k,:],Dis)
         dm=dist_m(A[k,:],Dis)
       F[k,1]=d
       F[k,2]=dm


       C = dominated(A[k,:], B)
       D = equal(A[k,:],B)
       
       Dis = total_ND(C,D,B,dim) # array for the single cells with expression
       Fd=0
       Fdm=0
       if F[k,0] >= 0 and len(Dis)>0:
         Fd=dist(A[k,:],Dis)
         Fdm=dist_m(A[k,:],Dis)
       F[k,3]=Fd
       F[k,4]=Fdm

       if k %1 ==0:
      #   print k
         # print S
         #print F
 #        print
         printProgressBar(k+1, len(A), prefix = 'Progress:', suffix = 'Complete', length = 60)
  
  end=time.time()
  print 
  print ('relapse time is ',end-start,'\n')

  print (L.shape,F.shape)
  return np.concatenate((L,F),axis=1)#,F_sc
  




def initial_pop():
	config.pop=[] #individaul's objective values as []

def my_rand():
	return random.random() * (V - U) - (V + U) / 2

def load_data():
	L=ReadFile.main(config.f,0,' ')
       	data=np.array(L)
	return data

def load_big_data(num):
	rline=""
	with open(config.f) as fp:
	    for i, line in enumerate(fp):
			if i == num:
			    rline=line
			elif i > num:
			    break
	line=rline.split()
	Ldata=[]
	for tmp in line[1:len(line)]:
		Ldata.append(float(tmp))
	Ldata.append(line[0])
	#print line
	#print num
	#print len(pop)
	config.pop.append(Ldata)
	#return line


def fitness_bk(indi):

	
	#L=[]
	df=config.df
	config.num += 1
	if config.num%100==0:
                printProgressBar(config.num + 1, config.N, prefix = 'Progress:', suffix = 'Complete', length = 100)
	for k in range(len(indi)):
		#print indi[k]
		df.set_index('col'+str(k))
		df=df[df['col'+str(k)]<indi[k]]
		if len(df) == 0:
                        break
	
	#f=1
	if len(df) >0:
		f=float(sum(df["S"]))/float(len(config.df)+1)
	if len(df) == 0:
                config.opti_num +=1
		f=0
	return f

def chunkIt(seq, num):
    if num ==0:
	    num =1 
    avg = len(seq) / float(num)
    out = []
    last = 0.0

    while last < len(seq):
        out.append(seq[int(last):int(last + avg)])
        last += avg

    return out

def get_line_num():
	#result = subprocess.check_output(['wc',config.f])
	result=subprocess.Popen(['wc',config.f], stdout=subprocess.PIPE).communicate()[0]
	line_num=result.split()[0]
	return int(line_num)

def get_chunks():
	line_num=get_line_num()
	chunks_num=int(line_num)/int(config.N)
	chunks=chunkIt(range(line_num),chunks_num)
	return chunks
def get_chunks_shuffle(data):
	line_num=len(data)
	chunks_num=int(line_num)/int(config.N)
	L=range(line_num)
	shuffle(L)
	chunks=chunkIt(L,chunks_num)
        data_list=[]
        #data_num=data[:,0:len(data[0,:])-1]
        for l in chunks:
                data_list.append(data[l,:].tolist())
	return data_list


def write_archive():
	mkdir(config.out_dir)
	sample=config.f.split('/')[-1].split('.')[0]
	#if config.Iter > 2:
	#	sample=config.f.split('/')[-2]
	new_out_dir=config.out_dir+'/'+sample
	mkdir(new_out_dir)
	f=new_out_dir+'/'+str(config.Iter)+'archive.txt'
	wf(f,config.archive,' ')
#        f=new_out_dir+'/'+str(config.Iter)+'F_sc_distance.txt'
 #       wf(f,config.F_sc,' ')
        config.archive=[]
        config.F_sc=[]

def mkdir(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)

def combine(L1,L2):
	L=[]
	for tmp in L1:
		if tmp not in L:
			L.append(tmp)
	for tmp in L2:
		if tmp not in L:
			L.append(tmp)

	return L

def wf(FileName, L,Sep):
        
        fw=open(FileName,'w')
        L1=[]
        for k in range (len(L)):
            temp=L[k]
#            f=F[k]
           
            for l in range (len(temp)):
                temp1=temp[l]
                if(l <>len(temp)-1):
                    fw.write('%s%s'%(temp1,Sep))
                if(l ==len(temp)-1):
                  fw.write('%s'%(temp1))
            #fw.write('%s'%(f))
            
            fw.write('\n')
        fw.close()  

# Print iterations progress
from sys import stdout
def printProgressBar (iteration, total, prefix = '', suffix = '', decimals = 1, length = 100, fill = '█'):
    """
    Call in a loop to create terminal progress bar
    @params:
        iteration   - Required  : current iteration (Int)
        total       - Required  : total iterations (Int)
        prefix      - Optional  : prefix string (Str)
        suffix      - Optional  : suffix string (Str)
        decimals    - Optional  : positive number of decimals in percent complete (Int)
        length      - Optional  : character length of bar (Int)
        fill        - Optional  : bar fill character (Str)
    """
    percent = ("{0:." + str(decimals) + "f}").format(100 * (iteration / float(total)))
    filledLength = int(length * iteration // total)
    bar = fill * filledLength + '-' * (length - filledLength)
    stdout.flush()
    stdout.write ('%s |%s| %s%% %s\r' % (prefix, bar, percent, suffix))
    #sys.stdout.write("\r%d%%" % i)
    
    # Print New Line on Complete
    if iteration == total: 
        print('\r')

# 
# Sample Usage
#      
