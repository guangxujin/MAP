
export NUMBAPRO_NVVM=/usr/local/cuda-9.1/nvvm/lib64/libnvvm.so
export NUMBAPRO_LIBDEVICE=/usr/local/cuda-9.1/nvvm/libdevice/

batch=1

device_num=3

num_each_batch=4

for k in {1..4}
do
    
	 #echo $k
	 echo 'Submitting sample #:'$k' to GUP device #: '$device_num
	 echo 
	 bash run_2.sh $k $device_num
done
