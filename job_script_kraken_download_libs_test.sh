#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:30:00 
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=1G
#SBATCH --job-name=kraken_download_libs_test_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

THREAD_NUM=8
FOLDER_NAME=test_libs_downloaded
FOLDER_PATH=/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${FOLDER_NAME}/
OUT_PATH=/work/mnikvell/data/Kraken2/dbs/

echo "folder name: ${FOLDER_NAME}"
echo "folder path: ${FOLDER_PATH}"
echo "output path: ${OUT_PATH}"

# create directories in scratch-dir
rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/${FOLDER_NAME}


# scratch directory
echo "content of scratch dir: $(ls -R /scratch/mnikvell/)"

# move to job directory
cd /scratch/mnikvell/kraken_job_${SLURM_JOBID}/


# download taxonomy
kraken2-build --download-taxonomy --threads ${THREAD_NUM} --db "${FOLDER_PATH}"

# download test subset of dbs
echo 'archaea'
kraken2-build --download-library archaea --threads ${THREAD_NUM} --db "${FOLDER_PATH}"

echo 'UniVec_Core'
kraken2-build --download-library UniVec_Core --threads ${THREAD_NUM} --db "${FOLDER_PATH}"

# check what folders are there now
echo "content of folder with transferred data in scratch dir: $(ls /scratch/mnikvell/kraken_job_${SLURM_JOBID}/${FOLDER_NAME}/)"

# copy outputs back to
cp -a $FOLDER_PATH $OUT_PATH

rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

conda deactivate


