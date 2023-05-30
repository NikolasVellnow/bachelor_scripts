#!/bin/bash



for file in *.bam
do	
	FILENAME="$file"
	FILENAME=${FILENAME%.bam*}
	echo $FILENAME
	
	samtools fasta -@ 4 $file > "$FILENAME".fasta
done

