#!/bin/bash

# fastq files of each run are in their own folder fastq.CrCp4GEX/L126 & fastq.CrCp4GEX/L130

here=/home/localadmin/Desktop/RESEARCH/SBobisse
data=$here/fastq.CrCp4GEX
outsub=$here/fastqMerged.CrCp4GEX
out=$here/fastqMerged/GEX

mkdir -p $outsub 
mkdir -p $out

# 1. concatenate fastq files from each run separately
run=('L126' 'L130')
for i in  "${run[@]}"
do
	rename 's/GEX/GEX_/g' $data/$i*gz
	
	ls $data/$i/*R1* | cut -d _ -f 1 | sort | uniq | \
	while read id
	do
		name=$(basename $id)
		echo $name
		echo $data/$i/*R1*.fastq.gz
		#done
		cat $data/$i/$name*R1*.fastq.gz > $outsub/${name}_S1_${i}_R1_001.fastq.gz
		cat $data/$i/$name*R2*.fastq.gz > $outsub/${name}_S1_${i}_R2_001.fastq.gz
		cat $data/$i/$name*I1*.fastq.gz > $outsub/${name}_S1_${i}_I1_001.fastq.gz
	done
done

# 2. concatenate fastq files from sub-merged fastq files
ls $outsub/*R1* | cut -d _ -f 1 | sort | uniq | \
while read id
do
	name=$(basename $id)
	echo $name
	echo $outsub/$name*R1*.fastq.gz
	#done
	cat $outsub/$name*R1*.fastq.gz > $out/${name}_S1_L001_R1_001.fastq.gz
	cat $outsub/$name*R2*.fastq.gz > $out/${name}_S1_L001_R2_001.fastq.gz
	cat $outsub/$name*I1*.fastq.gz > $out/${name}_S1_L001_I1_001.fastq.gz
done

