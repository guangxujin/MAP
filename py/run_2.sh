
f=$1
sample_dir=../3types_spea2_bcc_high_exheff/
device_num=$2
sample="`awk 'NR=="'"$f"'"' $sample_dir/0_allsamples.txt`"
echo $sample
echo $device_num

python SPEA2_numba.py $sample $device_num


