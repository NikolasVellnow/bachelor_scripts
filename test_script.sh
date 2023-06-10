#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:40:00 
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=12G
#SBATCH --job-name=kraken_build_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

DB_NAME=test
DB_PATH=/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/
OUT_PATH=/work/mnikvell/data/Kraken2/dbs/

echo "db name: ${DB_NAME}"
echo "db path: ${DB_PATH}"
echo "output path: ${OUT_PATH}"

# create directories in scratch-dir
rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}


# move to job directory
cd /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

# copy db data
cp -a -v /work/mnikvell/data/Kraken2/dbs/test_data/. $DB_PATH

# db directory
echo "content of db dir: $(ls -R /scratch/mnikvell/)"


# add genomes (already downloaded) to library

echo 'genome blood parasite'
kraken2-build --add-to-library /work/mnikvell/data/genomes/genbank/protozoa/GCA_001625125.1/GCA_001625125.1_ASM162512v1_genomic.fna \
--db "${DB_PATH}" --threads 16

# build database
kraken2-build --build --db "${DB_PATH}" --threads 16

# clean unnecessary files
kraken2-build --clean --db "${DB_PATH}" --threads 16

# copy outputs back to
cp -a $DB_PATH $OUT_PATH

rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

conda deactivate


