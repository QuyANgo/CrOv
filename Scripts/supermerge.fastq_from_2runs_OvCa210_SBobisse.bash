#!/bin/bash

here=/home/localadmin/Desktop/RESEARCH/SBobisse
data=$here/OvCa210.fastqMerged.20211201
out=$here/fastqMerged
 
mkdir -p $out

# 1. concatenate fastq files from each run separately
type=('VDJ' 'GEX')

for i in ${type[@]}
do

	ls $data/$i/*R1* | cut -d _ -f 1 | sort | uniq | \
	while read id
	do
		name=$(basename $id)
		echo $name
		echo $data/$i/*R1*.fastq.gz
		#done
		cat $data/$i/$name*R1*.fastq.gz > $out/$i/${name}_S1_L001_R1_001.fastq.gz
		cat $data/$i/$name*R2*.fastq.gz > $out/$i/${name}_S1_L001_R2_001.fastq.gz
		cat $data/$i/$name*I1*.fastq.gz > $out/$i/${name}_S1_L001_I1_001.fastq.gz
	done
	
done

