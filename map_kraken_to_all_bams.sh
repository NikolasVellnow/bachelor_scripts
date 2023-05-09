#!/bin/bash


# actual variables
#DB=$/scratch/mnikvell/kraken_job/PlusPF-8
#DB_NAME=$PlusPF_8
#OUT=$/scratch/mnikvell/kraken_job/kraken_outputs
#REPORT=$/scratch/mnikvell/kraken_job/kraken_outputs/report_EuPathDB46_S1


# variables for testing
DB=$/scratch/mnikvell/kraken_job/PlusPF-8
DB_NAME=$PlusPF_8
OUT=$/scratch/mnikvell/kraken_job/kraken_outputs
REPORT=$/scratch/mnikvell/kraken_job/kraken_outputs/report_EuPathDB46_S1


for file in *.fasta
do	
	FILENAME="$file"
	FILENAME=${FILENAME%.fasta*}
	echo $FILENAME
	OUT_FILENAME=
	
	fastqc $file -o /home/mnikvell/Desktop/work/data/outputs/
	kraken2 --db $DB --output "${OUT}/output_${FILENAME}" --use-names --report ${REPORT%_FILENAME} $file 
done

