#!/bin/bash

# cellranger vdj v6.1.1 for transcriptomic profiling - batch

here=/home/localadmin/Desktop/RESEARCH/SBobisse
ref=$here/../REFERENCES_sc/Ensembl104_GRCh38_gex_ref
fastq=$here/fastqMerged.20211201/run24.GEX
out=$here/cellranger/GEX.20211201.run24

mkdir -p $out
cd $out

sample=('OvCa210' 'OvCa1809')

for spl in "${sample[@]}"
do

ls $fastq/$spl* | cut -d _ -f 1 | sort | uniq | \
	while read id 
	do
		echo $id
		name=$(basename $id)
		echo $name
		#done
		#done

		cellranger count --id $name \
									 --transcriptome $ref \
									 --fastqs $fastq \
									 --sample $name \
									 --chemistry SC5P-R2 \
									 --localcores 6 \
									 --localmem 96
	done
	
done
