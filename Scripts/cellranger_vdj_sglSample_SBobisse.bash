#!/bin/bash

# cellranger vdj v6.1.1 for immune profiling

here=/home/localadmin/Desktop/RESEARCH/SBobisse
ref=$here/../REFERENCES_sc/Ensembl104_vdj_ref
fastq=$here/fastqMerged
out=$here/cellranger

mkdir -p $out
cd $out

cellranger vdj --id Ov1809 \
						 --fastqs $fastq \
						 --reference $ref \
						 --sample OvCa1809VDJ \
						 --chain auto \
						 --localcores 5 \
						 --localmem 96
						 