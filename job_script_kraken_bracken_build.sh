#!/bin/bash -l
#SBATCH --partition=long
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=2-00:00:00 
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=8G
#SBATCH --job-name=kraken_build_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

THREAD_NUM=32
DB_NAME=full_5_birds_with_bracken
DB_PATH=/scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}/
OUT_PATH=/work/mnikvell/data/Kraken2/dbs/

echo "db name: ${DB_NAME}"
echo "db path: ${DB_PATH}"
echo "output path: ${OUT_PATH}"

# create directories in scratch-dir
rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/
mkdir -p /scratch/mnikvell/kraken_job_${SLURM_JOBID}/${DB_NAME}


# scratch directory
echo "content of scratch dir: $(ls -R /scratch/mnikvell/)"

# move to job directory
cd /scratch/mnikvell/kraken_job_${SLURM_JOBID}/


# download taxonomy
kraken2-build --download-taxonomy --threads ${THREAD_NUM} --db "${DB_PATH}"

# download most dbs
echo 'archaea'
kraken2-build --download-library archaea --threads ${THREAD_NUM} --db "${DB_PATH}"

echo 'bacteria'
kraken2-build --download-library bacteria --threads ${THREAD_NUM} --db "${DB_PATH}"

echo 'plasmid'
kraken2-build --download-library plasmid --threads ${THREAD_NUM} --db "${DB_PATH}"

echo 'viral'
kraken2-build --download-library viral --threads ${THREAD_NUM} --db "${DB_PATH}"

echo 'human'
kraken2-build --download-library human --threads ${THREAD_NUM} --db "${DB_PATH}"

echo 'fungi'
kraken2-build --download-library fungi --threads ${THREAD_NUM} --db "${DB_PATH}"

echo 'plant'
kraken2-build --download-library plant --threads ${THREAD_NUM} --db "${DB_PATH}"

echo 'protozoa'
kraken2-build --download-library protozoa --threads ${THREAD_NUM} --db "${DB_PATH}"

echo 'UniVec_Core'
kraken2-build --download-library UniVec_Core --threads ${THREAD_NUM} --db "${DB_PATH}"


# add genomes (already downloaded) to library
echo 'genome chicken'
kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_016699485.1/GCA_016699485.1_bGalGal1.mat.broiler.GRCg7b_genomic.fna \
--db "${DB_PATH}" --threads ${THREAD_NUM}

echo 'genome great tit'
kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_001522545.3/GCA_001522545.3_Parus_major1.1_genomic.fna \
--db "${DB_PATH}" --threads ${THREAD_NUM}

echo 'genome blue tit'
kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_002901205.1/GCA_002901205.1_cyaCae2_genomic.fna \
--db "${DB_PATH}" --threads ${THREAD_NUM}

echo 'genome zebra finch'
kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_003957565.4/GCA_003957565.4_bTaeGut1.4.pri_genomic.fna \
--db "${DB_PATH}" --threads ${THREAD_NUM}

echo 'genome Tibetan ground-tit'
kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_000331425.1/GCA_000331425.1_PseHum1.0_genomic.fna \
--db "${DB_PATH}" --threads ${THREAD_NUM}

echo 'genome blood parasite'
kraken2-build --add-to-library /work/mnikvell/data/genomes/genbank/protozoa/GCA_001625125.1/GCA_001625125.1_ASM162512v1_genomic.fna \
--db "${DB_PATH}" --threads ${THREAD_NUM}


# build database
kraken2-build --build --db "${DB_PATH}" --threads ${THREAD_NUM}

# generate Bracken database file (databaseXmers.kmer_distrib)
bracken-build -d "${DB_PATH}" -t ${THREAD_NUM} -k 35 -l 150

# clean unnecessary files
kraken2-build --clean --db "${DB_PATH}" --threads ${THREAD_NUM}

# copy outputs back to
cp -a $DB_PATH $OUT_PATH

rm -rf /scratch/mnikvell/kraken_job_${SLURM_JOBID}/

conda deactivate


