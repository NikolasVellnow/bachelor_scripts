#!/bin/bash


mkdir subsets

for file in *.bam
do	
	FILENAME="$file"
	FILENAME=${FILENAME%.bam*}
	echo $FILENAME
	samtools view -bo "$FILENAME"_subset.bam -s 123.001 "$file"
done

# move subset-bams into the subset directory
mv *_subset.bam subsets/
