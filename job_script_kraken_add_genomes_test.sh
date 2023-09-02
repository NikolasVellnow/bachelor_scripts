#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=01:50:00 
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=1G
#SBATCH --job-name=kraken_add_genomes_test_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

THREAD_NUM=8
SOURCE_NAME=/home/mnikvell/Desktop/work/data/Kraken2/dbs/test_libs_downloaded/
FOLDER_NAME=test_libs_added_genomes
FOLDER_PATH=/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${FOLDER_NAME}/
OUT_PATH=/work/mnikvell/data/Kraken2/dbs/

echo "folder name: ${FOLDER_NAME}"
echo "folder path: ${FOLDER_PATH}"
echo "output path: ${OUT_PATH}"

# create directories in scratch-dir (and delete previous ones)
rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

# copy already downloaded libraries to scratch-dir
cp -r $SOURCE_NAME $FOLDER_PATH

# scratch directory
echo "content of mnikvell in scratch dir: $(ls /scratch/mnikvell/)"
echo "content of folder with transferred data in scratch dir: $(ls /scratch/mnikvell/kraken_job_${SLURM_JOBID}/${FOLDER_NAME}/)"

# move to job directory
cd /scratch/mnikvell/kraken_job_${SLURM_JOBID}/


# add chicken and P. major genomes (already downloaded) to library
echo 'genome chicken'
kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_016699485.1/GCA_016699485.1_bGalGal1.mat.broiler.GRCg7b_genomic.fna \
--db "${FOLDER_PATH}" --threads ${THREAD_NUM}

echo 'genome great tit'
kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_001522545.3/GCA_001522545.3_Parus_major1.1_genomic.fna \
--db "${FOLDER_PATH}" --threads ${THREAD_NUM}


# check what folders are there now
echo "content of folder with transferred data in scratch dir: $(ls /scratch/mnikvell/kraken_job_${SLURM_JOBID}/${FOLDER_NAME}/)"

# copy outputs back to
cp -a $FOLDER_PATH $OUT_PATH

rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

conda deactivate


