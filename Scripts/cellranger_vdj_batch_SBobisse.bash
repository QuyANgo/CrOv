#!/bin/bash

# cellranger vdj v6.1.1 for immune profiling - batch

here=/home/localadmin/Desktop/RESEARCH/SBobisse
ref=$here/../REFERENCES_sc/Ensembl104_vdj_ref
fastq=$here/fastqMerged/VDJ
out=$here/cellranger/VDJ

mkdir -p $out
cd $out

ls $fastq/* | cut -d _ -f 1 | sort | uniq | \
while read id 
do
	echo $id
	name=$(basename $id)
	echo $name
	#done

	cellranger vdj --id $name \
							 --fastqs $fastq \
							 --reference $ref \
							 --sample $name \
							 --chain auto \
							 --localcores 6 \
							 --localmem 96
done

