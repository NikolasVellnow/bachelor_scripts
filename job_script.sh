#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --time=02:00:00 
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=12G
#SBATCH --job-name=kraken_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

DB_NAME=PlusPFP-16
FILE_NAME=s5_EKDN230004354-1A_HNHMFDSX5_L3_sorted_dedup.bam
DB_PATH=/scratch/mnikvell/kraken_job/${DB_NAME}/

OUT_PATH=/scratch/mnikvell/kraken_job/kraken_outputs/
OUTPUT_NAME=output_${FILE_NAME}_${DB_NAME}
REPORT_NAME=report_${FILE_NAME}_${DB_NAME}
FILE_PATH=/work/mnikvell/data/mapped_reads/


# create directories in scratch-dir
mkdir /scratch/mnikvell/kraken_job/
mkdir /scratch/mnikvell/kraken_job/kraken_outputs

# move database to scratch-dir
mv /work/mnikvell/data/Kraken2/dbs/${DB_NAME} /scratch/mnikvell/kraken_job/

# move file to scratch-dir
mv ${FILE_PATH}${FILE_NAME} /scratch/mnikvell/kraken_job/

# move to job directory
cd scratch/mnikvell/kraken_job/

kraken2 \
--db "${DB_PATH}${DB_NAME}" \
--output "${OUT_PATH}${OUTPUT_NAME}" \
--use-names \
--report "${OUT_PATH}${REPORT_NAME}" \
"${FILE_NAME}" 


conda deactivate


