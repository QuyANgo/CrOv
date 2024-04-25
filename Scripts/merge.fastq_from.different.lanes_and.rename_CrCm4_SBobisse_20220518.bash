#!/bin/bash

here=/home/localadmin/Desktop/RESEARCH/SBobisse
data=$here/fastqCrCm4
out=$here/fastqMerged

mkdir -p $out

## 1. for GEX samples
cd $data/CrCm4GEX
rename 's/CrCm45/CrCm4/g' *

ls ./*R1* | cut -d _ -f 1 | sort | uniq | \
while read id
do
	name=$(basename $id)
	echo $name
	echo $name*R1*.fastq.gz
	#done
	cat $name*R1*.fastq.gz > $out/GEX/${name}_S1_L001_R1_001.fastq.gz
	cat $name*R2*.fastq.gz > $out/GEX/${name}_S1_L001_R2_001.fastq.gz
	cat $name*I1*.fastq.gz > $out/GEX/${name}_S1_L001_I1_001.fastq.gz

done


## 2. for VDJ samples
cd $data/CrCm4VDJ
rename 's/CrCm45/CrCm4/g' *

ls ./*R1* | cut -d _ -f 1 | sort | uniq | \
while read id
do
	name=$(basename $id)
	echo $name
	echo $name*R1*.fastq.gz
	#done
	cat $name*R1*.fastq.gz > $out/VDJ/${name}_S1_L001_R1_001.fastq.gz
	cat $name*R2*.fastq.gz > $out/VDJ/${name}_S1_L001_R2_001.fastq.gz
	cat $name*I1*.fastq.gz > $out/VDJ/${name}_S1_L001_I1_001.fastq.gz

done

