#!/bin/bash



for file in *.bam
do	
	samtools index $file
done

