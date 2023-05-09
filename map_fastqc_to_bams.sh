#!/bin/bash



for file in *.bam
do	
	FILENAME="$file"
	FILENAME=${FILENAME%.bam*}
	echo $FILENAME
	
	fastqc $file -o /home/mnikvell/Desktop/work/data/outputs/
done

