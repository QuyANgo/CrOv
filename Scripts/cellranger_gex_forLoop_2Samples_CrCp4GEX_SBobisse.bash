#!/bin/bash

# cellranger vdj v6.1.1 for transcriptomic profiling - batch

here=/home/localadmin/Desktop/RESEARCH/SBobisse
ref=$here/../REFERENCES_sc/Ensembl104_GRCh38_gex_ref
fastq=$here/fastqMerged.CrCp4GEX
out=$here/cellranger

mkdir -p $out

cd $fastq
rename 's/CrCp4GEX_S1_L126/CrCp4GEX126_S1_L001/g' *gz
rename 's/CrCp4GEX_S1_L130/CrCp4GEX130_S1_L001/g' *gz

cd $out
run=('126' '130')

for i in "${run[@]}"
do
	ls $fastq/CrCp4GEX${i}*R1* | cut -d _ -f 1 | sort | uniq | \
	while read id 
	do
		echo $id
		name=$(basename $id)
		echo $name
		#done

		cellranger count --id $name \
								 --transcriptome $ref \
								 --fastqs $fastq \
								 --sample $name \
								 --chemistry SC5P-R2 \
								 --localcores 10 \
								 --localmem 96
	done
done
