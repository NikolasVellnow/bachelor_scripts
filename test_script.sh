#!/bin/bash

VAR=999




DB_NAME=PlusPFP-16
DB_PATH=/work/mnikvell/kraken_job_${VAR}/${DB_NAME}/
OUT_PATH=/work/mnikvell/kraken_job_${VAR}/kraken_outputs_${VAR}/
FILE_PATH=/work/mnikvell/data/unmapped_reads/subsets/

echo "db name: ${DB_NAME}"
echo "db path: ${DB_PATH}"
echo "output path: ${OUT_PATH}"
echo "file path: ${FILE_PATH}"

# create directories in scratch-dir
rm -rf /work/mnikvell/kraken_job_${VAR}/
mkdir -p /work/mnikvell/kraken_job_${VAR}/
mkdir -p /work/mnikvell/kraken_job_${VAR}/kraken_outputs
mkdir -p /work/mnikvell/kraken_job_${VAR}/${DB_NAME}

# move database to scratch-dir
cp -a -v "/work/mnikvell/data/Kraken2/dbs/${DB_NAME}/." "/work/mnikvell/kraken_job_${VAR}/${DB_NAME}/"
echo "content of job dir: $(ls /work/mnikvell/kraken_job_${VAR}/)"
echo "content of job/db dir: $(ls /work/mnikvell/kraken_job_${VAR}/${DB_NAME}/)"

echo "content of db dir: $(ls ${DB_PATH})"

# move to file directory
cd /work/mnikvell/data/unmapped_reads/
echo "content of file dir: $(ls $FILE_PATH)"

# move to job directory
cd /work/mnikvell/kraken_job_${VAR}/


for file in "${FILE_PATH}"S*.fasta
do	
	echo "file: ${file}"
	FILE_NAME=$(basename "$file")
	#FILE_NAME="${FILE_NAME}.fasta"
	echo "file name: ${FILE_NAME}"
	OUTPUT_NAME=output_${FILE_NAME}_${DB_NAME}
	echo "output name: ${OUTPUT_NAME}"
	REPORT_NAME=report_${FILE_NAME}_${DB_NAME}
	echo "report name: ${REPORT_NAME}"
	
	# move file to scratch-dir
	cp -v ${FILE_PATH}${FILE_NAME} /work/mnikvell/kraken_job_${VAR}/

	# delete fasta-file from scratch dir after classifying it
	rm "/work/mnikvell/kraken_job_${VAR}/${FILE_NAME}"

done

rm -rf /work/mnikvell/kraken_job_${VAR}/

