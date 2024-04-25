#!/bin/bash

here=/home/localadmin/Desktop/RESEARCH/SBobisse
data=$here/fastq/20211201
out=$here/fastqMerged

mkdir -p $out

cd $data
rename 's/-V/VDJ_/g' *
rename 's/-G/GEX_/g' *
rename 's/1809G/1809GEX_/g' *

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
#cd $out
#rename 's/.GEX/GEX/g' *
#rename 's/.VDJ/VDJ/g' *
#rename 's/R1.fastq.gz/S1_L002_R1_001.fastq.gz/g' *
#rename 's/R2.fastq.gz/S1_L002_R2_001.fastq.gz/g' *
#rename 's/I1.fastq.gz/S1_L002_I1_001.fastq.gz/g' *

done


# 3. organize samples according to GEX or VDJ
mkdir -p $out/GEX $out/VDJ
mv $out/*VDJ_* $out/VDJ
mv $out/*GEX_* $out/GEX
