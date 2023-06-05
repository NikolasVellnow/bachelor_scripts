#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:10:00 
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=12G
#SBATCH --job-name=kraken_build_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

DB_NAME=full
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

# download taxonomy
kraken2-build --download-taxonomy --db "${DB_PATH}"

# install libraries
echo 'installing archaea'
kraken2-build --download-library archaea --db "${DB_PATH}"

echo 'installing bacteria'
kraken2-build --download-library bacteria --db "${DB_PATH}"

echo 'installing plasmid'
kraken2-build --download-library plasmid --db "${DB_PATH}"

echo 'installing viral'
kraken2-build --download-library viral --db "${DB_PATH}"

echo 'installing human'
kraken2-build --download-library human --db "${DB_PATH}"

echo 'installing fungi'
kraken2-build --download-library fungi --db "${DB_PATH}"

echo 'installing plant'
kraken2-build --download-library plant --db "${DB_PATH}"

echo 'installing protozoa'
kraken2-build --download-library protozoa --db "${DB_PATH}"

echo 'installing UniVec_Core'
kraken2-build --download-library UniVec_Core --db "${DB_PATH}"


# add genomes (already downloaded) to library

echo 'genome great tit'
kraken2-build --add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_001522545.3/GCA_001522545.3_Parus_major1.1_genomic.fna \
--db "${DB_PATH}"

echo 'genome chicken'
kraken2-build --add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_016699485.1/GCA_016699485.1_bGalGal1.mat.broiler.GRCg7b_genomic.fna \
--db "${DB_PATH}"

echo 'genome blood parasite'
kraken2-build --add-to-library /work/mnikvell/data/genomes/genbank/protozoa/GCA_001625125.1/GCA_001625125.1_ASM162512v1_genomic.fna \
--db "${DB_PATH}"

# build database
kraken2-build --build --db "${DB_PATH}" --threads 16



# copy outputs back to
cp -a $DB_PATH $OUT_PATH

rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

conda deactivate


