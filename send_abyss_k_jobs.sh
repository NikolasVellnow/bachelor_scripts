#!/bin/bash


SCRIPT_PATH=${PWD}


for kc in 2 3; do
	
	for k in `seq 70 5 95`;do
		sbatch "${SCRIPT_PATH}/job_script_abyss_test_k.sh" ${k} ${kc}
	done
done


	
