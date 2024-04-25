#!/bin/bash

here=/home/localadmin/Desktop/RESEARCH/SBobisse
data=$here/fastq
out=$here/fastqMerged

mkdir -p $out

ls $data/*R1* | cut -d _ -f 1 | sort | uniq | \
while read id
do

# 1. merge
name=$(basename $id)
echo $name
echo $data/$name*R1*.fastq.gz
#done
cat $data/$name*R1*.fastq.gz > $out/${name}_S1_L002_R1_001.fastq.gz
cat $data/$name*R2*.fastq.gz > $out/${name}_S1_L002_R2_001.fastq.gz
cat $data/$name*I1*.fastq.gz > $out/${name}_S1_L002_I1_001.fastq.gz

# 2. rename to match standard naming
cd $out
rename 's/.GEX/GEX/g' *
rename 's/.VDJ/VDJ/g' *
#rename 's/R1.fastq.gz/S1_L002_R1_001.fastq.gz/g' *
#rename 's/R2.fastq.gz/S1_L002_R2_001.fastq.gz/g' *
#rename 's/I1.fastq.gz/S1_L002_I1_001.fastq.gz/g' *

# 3. organize samples according to GEX or VDJ
mkdir -p $out/GEX $out/VDJ
mv $out/*VDJ_* $out/VDJ
mv $out/*GEX_* $out/GEX

done

