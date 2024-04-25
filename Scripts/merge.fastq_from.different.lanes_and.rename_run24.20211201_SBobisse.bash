#!/bin/bash

here=/home/localadmin/Desktop/RESEARCH/SBobisse
data=$here/fastq.20211201/run24
out=$here/fastqMerged.20211201/run24.GEX

mkdir -p $out

cd $data
#rename 's/-V/VDJ_/g' *
rename 's/-G/GEX_/g' *
rename 's/1809G/1809GEX_/g' *

ls $data/*GEX*R1* | cut -d _ -f 1 | sort | uniq | \
while read id
do

# 1. merge
name=$(basename $id)
echo $name
echo $data/$name*R1*.fastq.gz
#done
cat $data/$name*R1*.fastq.gz > $out/${name}_S1_L001_R1_001.fastq.gz
cat $data/$name*R2*.fastq.gz > $out/${name}_S1_L001_R2_001.fastq.gz
cat $data/$name*I1*.fastq.gz > $out/${name}_S1_L001_I1_001.fastq.gz

done

