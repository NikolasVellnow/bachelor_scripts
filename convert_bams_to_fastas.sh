#!/bin/bash



for file in *.bam
do	
	FILENAME="$file"
	FILENAME=${FILENAME%.bam*}
	echo $FILENAME
	
	samtools fasta $file > "$FILENAME".fasta
done

