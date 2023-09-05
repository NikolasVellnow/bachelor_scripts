#!/bin/bash

INPUT_PATH=$1

SCRIPT_PATH=${PWD}

cd ${INPUT_PATH}
for file in *_unmapped_subset.fasta
do
	sbatch "${SCRIPT_PATH}/job_script_kraken_bracken_classification_test.sh" ${file}

done
	
