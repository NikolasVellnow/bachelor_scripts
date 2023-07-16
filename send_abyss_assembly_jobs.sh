#!/bin/bash


SCRIPT_PATH=${PWD}

# input path to directory with sample .fq-files
DATA_PATH=$1

k=85
kc=2

cd ${DATA_PATH}

for file in *.bam
do
	sbatch "${SCRIPT_PATH}/job_script_abyss_assembly.sh" ${k} ${kc} ${file} ${DATA_PATH}

done



	
