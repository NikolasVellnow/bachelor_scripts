#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:01:50 
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=6G
#SBATCH --job-name=kraken_build_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

THREAD_NUM=32
#DB_NAME=full_5_birds
DB_NAME=viral_5_birds_2
DB_PATH=/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/
OUT_PATH=/work/mnikvell/data/Kraken2/dbs/

echo "db name: ${DB_NAME}"
echo "db path: ${DB_PATH}"
echo "output path: ${OUT_PATH}"

# create directories in scratch-dir
rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}


# move database to scratch-dir
cp -a -v "/work/mnikvell/data/Kraken2/dbs/${DB_NAME}/." "/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/"
echo "content of job dir: $(ls /scratch/mnikvell/kraken_job_${SLURM_JOBID}/)"


# scratch directory
echo "content of scratch dir: $(ls -R /scratch/mnikvell/)"

# move to job directory
cd /scratch/mnikvell/kraken_job_${SLURM_JOBID}/


# download taxonomy
kraken2-build --download-taxonomy --threads ${THREAD_NUM} --db "${DB_PATH}"


# generate Bracken database file (databaseXmers.kmer_distrib)
bracken-build -d "${DB_PATH}" -t ${THREAD_NUM} -k 35 -l 150

# copy outputs back to
cp -a $DB_PATH $OUT_PATH

rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

conda deactivate


