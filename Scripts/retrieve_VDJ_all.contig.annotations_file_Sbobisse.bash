# copy all_contig_annotations files of cell ranger

here=/home/localadmin/Desktop/RESEARCH/SBobisse/cellranger/VDJ

for i in `ls $here`
do
	cp $here/$i/outs/all_contig_annotations.csv $here/${i}_all_contig_annotation.csv
done
	
