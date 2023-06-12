#!/bin/bash

INPUT_PATH=$1

SCRIPT_PATH=${PWD}

cd ${INPUT_PATH}
for file in *_unmapped.fasta
do
	sbatch "${SCRIPT_PATH}/job_script_kraken.sh" ${file}

done
	
