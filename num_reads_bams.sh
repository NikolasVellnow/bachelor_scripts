#!/bin/bash


touch num_reads.txt

for file in *.bam
do	
	printf '%s\t%s\n' $file $(samtools view -c $file)

done > num_reads.txt

