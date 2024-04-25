#!/bin/bash

here=/home/localadmin/Desktop/RESEARCH/SBobisse
data=$here/fastq
out=$here/fastqMerged/VDJ

mkdir -p $out

cd $data
rename 's/T0VDJA/VDJ_A/g' *
rename 's/T0VDJB/VDJ_B/g' *
rename 's/T0VDJC/VDJ_C/g' *
rename 's/T0VDJD/VDJ_D/g' *

ls $data/0SM8*R1* | cut -d _ -f 1 | sort | uniq | \
while read id
	do
	echo $id
	#done

	cat $id*R1*.fastq.gz > $out/CrCm6VDJ_S1_L002_R1_001.fastq.gz
	cat $id*R2*.fastq.gz > $out/CrCm6VDJ_S1_L002_R2_001.fastq.gz
	cat $id*I1*.fastq.gz > $out/CrCm6VDJ_S1_L002_I1_001.fastq.gz

done

