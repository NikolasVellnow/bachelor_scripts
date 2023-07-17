#!/bin/bash


KREPORT_TO_KRONA_PATH=/home/mnikvell/miniconda3/envs/kraken/bin/kreport2krona.py
IN_PATH=$1
OUT_PATH=$2



# move to input dir
cd ${IN_PATH}

for file in report_*
do	
	echo ${file}
	OUT_FILENAME="${OUT_PATH}${file#*report_}_from_kraken_report.krona"
	echo $OUT_FILENAME
	python3 ${KREPORT_TO_KRONA_PATH} -r ${file} -o ${OUT_FILENAME}
	ktImportText ${OUT_FILENAME} -o "${OUT_FILENAME}.html"	

done

