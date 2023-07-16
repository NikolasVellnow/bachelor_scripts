#!/bin/bash


SCRIPT_PATH=${PWD}

# input path to directory with sample .fq-files
DATA_PATH=$1

cd ${DATA_PATH}



for file in *.bam
do
	FILENAME="$file"
	FILENAME=${FILENAME%.bam*}
	echo ${FILENAME}
	samtools collate -u -@ 4 -O ${file} | samtools fastq -@ 4 -1 "${FILENAME}_paired1.fq.gz" -2 "${FILENAME}_paired2.fq.gz" -s ${FILENAME}_"singletons.fq.gz"
done




	
