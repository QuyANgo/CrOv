#!/bin/bash

here=/home/localadmin/Desktop/RESEARCH/SBobisse
data=$here/fastqMerged.20211201
out=$here/fastqMerged/GEX

mkdir -p $out

cd $data/run30.GEX
rename 's/L001/L30/g' *

cd $data/run24.GEX
rename 's/L001/L24/g' *

cp $data/run30.GEX/*gz $data
cp $data/run24.GEX/*gz $data

ls $data/*R1* | cut -d _ -f 1 | sort | uniq | \
while read id
do

name=$(basename $id)
echo $name
echo $data/$name*R1*.fastq.gz
#done
cat $data/$name*R1*.fastq.gz > $out/${name}_S1_L001_R1_001.fastq.gz
cat $data/$name*R2*.fastq.gz > $out/${name}_S1_L001_R2_001.fastq.gz
cat $data/$name*I1*.fastq.gz > $out/${name}_S1_L001_I1_001.fastq.gz

done

rm $data/*gz

