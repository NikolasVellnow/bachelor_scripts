#!/bin/bash



for file in *.bam
do	
	samtools index -@ 4 $file
done

