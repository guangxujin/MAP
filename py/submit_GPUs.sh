
export NUMBAPRO_NVVM=/usr/local/cuda-9.1/nvvm/lib64/libnvvm.so
export NUMBAPRO_LIBDEVICE=/usr/local/cuda-9.1/nvvm/libdevice/

batch=$1

device_num=$batch

num_each_batch=32

for k in {1..32}
do
    
	 #echo $k
	 batch_num=$device_num
	 let "sample_num = $batch_num * $num_each_batch"
	 
	 sample_num=$(($sample_num + k))
	 echo 'Submitting sample #:'$sample_num' to GUP device #: '$device_num
	 echo 
	 bash run_2.sh $sample_num $device_num
done
