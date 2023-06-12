#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=02:00:00 
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=6G
#SBATCH --job-name=kraken_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

FILE_NAME=$1
DB_NAME=full
DB_PATH=/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/
OUT_PATH=/scratch/mnikvell/kraken_job_${SLURM_JOBID}/kraken_outputs_${SLURM_JOBID}/
FILE_PATH=/work/mnikvell/data/unmapped_reads/

echo "file name: ${FILE_NAME}"
echo "db name: ${DB_NAME}"
echo "db path: ${DB_PATH}"
echo "output path: ${OUT_PATH}"
echo "file path: ${FILE_PATH}"

# create directories in scratch-dir
rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/kraken_outputs_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}


# move database to scratch-dir
cp -a -v "/work/mnikvell/data/Kraken2/dbs/${DB_NAME}/." "/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/"
echo "content of job dir: $(ls /scratch/mnikvell/kraken_job_${SLURM_JOBID}/)"


# move to job directory
cd /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

	

OUTPUT_NAME=output_${FILE_NAME}_${DB_NAME}
echo "output name: ${OUTPUT_NAME}"
REPORT_NAME=report_${FILE_NAME}_${DB_NAME}
echo "report name: ${REPORT_NAME}"
	
	
# move file to scratch-dir
cp -v ${FILE_PATH}${FILE_NAME} /scratch/mnikvell/kraken_job_${SLURM_JOBID}/


kraken2 \
--db ${DB_PATH} \
--output ${OUT_PATH}${OUTPUT_NAME} \
--use-names \
--report ${OUT_PATH}${REPORT_NAME} \
--threads 32 \
${FILE_NAME}

# delete fasta-file from scratch dir after classifying it
rm "/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${FILE_NAME}"


# copy outputs back to
cp -a "${OUT_PATH}." /"work/mnikvell/data/unmapped_reads/kraken_outputs_full_db/"
rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

conda deactivate


