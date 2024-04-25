#!/bin/bash

# cellranger vdj v6.1.1 for immune profiling

here=/home/localadmin/Desktop/RESEARCH/SBobisse
ref=$here/../REFERENCES_sc/Ensembl104_vdj_ref
fastq=$here/fastqMerged
out=$here/cellranger/VDJ

mkdir -p $out
cd $out

cellranger vdj --id CrCm4VDJ \
						 --fastqs $fastq \
						 --reference $ref \
						 --sample CrCm4VDJ \
						 --chain auto \
						 --localcores 8 \
						 --localmem 96
						 