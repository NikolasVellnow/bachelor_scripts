#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:55:00 
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=12G
#SBATCH --job-name=kraken_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

THREAD_NUM=16
FILE_NAME=$1
DB_NAME=full_5_birds_kraken_only_db
DB_PATH=/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/
OUT_PATH=/scratch/mnikvell/kraken_job_${SLURM_JOBID}/kraken_outputs_${SLURM_JOBID}/
FILE_PATH=/work/mnikvell/data/unmapped_reads/fasta_files/

echo "file name: ${FILE_NAME}"
echo "db name: ${DB_NAME}"
echo "db path: ${DB_PATH}"
echo "output path: ${OUT_PATH}"
echo "file path: ${FILE_PATH}"

# create directories in scratch-dir
rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/kraken_outputs_${SLURM_JOBID}/


# move database to scratch-dir
cp -R "/work/mnikvell/data/Kraken2/dbs/${DB_NAME}/" "/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/"
echo "content of job dir: $(ls /scratch/mnikvell/kraken_job_${SLURM_JOBID}/)"


# move to job directory
cd /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

	
OUTPUT_NAME=output_${FILE_NAME%.*}_${DB_NAME}.kraken
echo "output name: ${OUTPUT_NAME}"
CLASSIFIED_NAME=classified_${FILE_NAME%.*}_${DB_NAME}.fasta
echo "classified output name: ${CLASSIFIED_NAME}"
UNCLASSIFIED_NAME=unclassified_${FILE_NAME%.*}_${DB_NAME}.fasta
echo "unclassified output name: ${UNCLASSIFIED_NAME}"
REPORT_NAME=report_${FILE_NAME%.*}_${DB_NAME}.kreport
echo "report name: ${REPORT_NAME}"
	
	
# move file to scratch-dir
cp -v ${FILE_PATH}${FILE_NAME} /scratch/mnikvell/kraken_job_${SLURM_JOBID}/


kraken2 \
--db ${DB_PATH} \
--output ${OUT_PATH}${OUTPUT_NAME} \
--use-names \
--report ${OUT_PATH}${REPORT_NAME} \
--classified-out ${OUT_PATH}${CLASSIFIED_NAME} \
--unclassified-out ${OUT_PATH}${UNCLASSIFIED_NAME} \
--confidence 0.1 \
--threads ${THREAD_NUM} \
${FILE_NAME}

# delete fasta-file from scratch dir after classifying it
rm "/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${FILE_NAME}"

cd ${OUT_PATH}
# zip large files
gzip output*
gzip classified*
gzip unclassified*

# copy outputs back to
cp -a "${OUT_PATH}." /"work/mnikvell/data/outputs/kraken_outputs/kraken_outputs_${DB_NAME}_db/"
rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

conda deactivate


