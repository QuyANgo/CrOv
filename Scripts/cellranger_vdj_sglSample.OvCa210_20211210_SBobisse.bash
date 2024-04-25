#!/bin/bash

# cellranger vdj v6.1.1 for immune profiling

here=/home/localadmin/Desktop/RESEARCH/SBobisse
ref=$here/../REFERENCES_sc/Ensembl104_vdj_ref
fastq=$here/fastqMerged/VDJ
out=$here/cellranger/VDJ

mkdir -p $out
cd $out

name='OvCa210VDJ'

cellranger vdj --id $name \
					 --fastqs $fastq \
					 --reference $ref \
					 --sample $name \
					 --chain auto \
					 --localcores 5 \
					 --localmem 48
						 