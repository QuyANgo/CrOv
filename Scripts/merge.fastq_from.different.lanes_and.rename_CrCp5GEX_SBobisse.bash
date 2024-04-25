#!/bin/bash

here=/home/localadmin/Desktop/RESEARCH/SBobisse
data=$here/fastqCrCp5GEX
out=$here/fastqMerged/GEX

mkdir -p $out

#1. rename samples
cd $data
rename 's/GEXA/GEX_A/g' *
rename 's/GEXB/GEX_B/g' *
rename 's/GEXC/GEX_C/g' *
rename 's/GEXD/GEX_D/g' *

# 2. merge
ls $data/*R1* | cut -d _ -f 1 | sort | uniq | \
while read id
do
	name=$(basename $id)
	echo $name
	echo $data/$name*R1*.fastq.gz
	#done
	cat $data/$name*R1*.fastq.gz > $out/${name}_S1_L006_R1_001.fastq.gz
	cat $data/$name*R2*.fastq.gz > $out/${name}_S1_L006_R2_001.fastq.gz
	cat $data/$name*I1*.fastq.gz > $out/${name}_S1_L006_I1_001.fastq.gz

done

