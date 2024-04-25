#!/bin/bash

# cellranger vdj v6.1.1 for transcriptomic profiling - batch

here=/home/localadmin/Desktop/RESEARCH/SBobisse
ref=$here/../REFERENCES_sc/Ensembl104_GRCh38_gex_ref
fastq=$here/fastqMerged/GEX
out=$here/cellranger/GEX

mkdir -p $out
cd $out

ls $fastq/CrCp5GEX_* | cut -d _ -f 1 | sort | uniq | \
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
							    --localcores 6 \
							    --localmem 96
done

