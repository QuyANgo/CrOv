#!/bin/bash

here=/home/localadmin/Desktop/RESEARCH/SBobisse
data=$here/OvCa210.fastq.20211201/run24
out=$here/OvCa210.fastqMerged.20211201

mkdir -p $out

cd $data
rename 's/-V/VDJ_/g' *gz
rename 's/-G/GEX_/g' *gz

type=('VDJ' 'GEX')

for i in ${type[@]}
do

	ls $data/*$i*R1* | cut -d _ -f 1 | sort | uniq | \
	while read id
	do
		name=$(basename $id)
		echo $name
		echo $data/$name*R1*.fastq.gz
		#done
		cat $data/$name*R1*.fastq.gz > $out/$i/${name}_S1_L024_R1_001.fastq.gz
		cat $data/$name*R2*.fastq.gz > $out/$i/${name}_S1_L024_R2_001.fastq.gz
		cat $data/$name*I1*.fastq.gz > $out/$i/${name}_S1_L024_I1_001.fastq.gz
	done
	
done

