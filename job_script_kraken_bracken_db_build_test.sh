#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:59:00 
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=braken_build_test_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

THREAD_NUM=32
SOURCE_NAME=/home/mnikvell/Desktop/work/data/Kraken2/dbs/test_kraken/
DB_NAME=test_kraken_bracken
DB_PATH=/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/
OUT_PATH=/work/mnikvell/data/Kraken2/dbs/

echo "db name: ${DB_NAME}"
echo "db path: ${DB_PATH}"
echo "output path: ${OUT_PATH}"


# create directories in scratch-dir
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

# copy kraken db into scratch-dir
cp -R $SOURCE_NAME $DB_PATH

# scratch directory
echo "content of mnikvell in scratch dir: $(ls /scratch/mnikvell/)"
echo "content of folder with transferred data in scratch dir: $(ls /scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/)"

# move to job directory
cd /scratch/mnikvell/kraken_job_${SLURM_JOBID}/


# generate Bracken database file (databaseXmers.kmer_distrib)
echo "start building bracken db"
bracken-build -d "${DB_PATH}" -t ${THREAD_NUM} -k 35 -l 150

# clean unnecessary files
echo "start cleaning unneessary files"
kraken2-build --clean --db "${DB_PATH}" --threads ${THREAD_NUM}

# check what folders are there now
echo "content of folder with build db in scratch dir: $(ls /scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/)"


# copy outputs back to
cp -a $DB_PATH $OUT_PATH

rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

conda deactivate


