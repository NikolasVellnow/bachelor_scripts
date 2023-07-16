#!/bin/bash -l
#SBATCH --partition=med
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=02:59:00 
#SBATCH --cpus-per-task=32
#SBATCH --mem-per-cpu=500M
#SBATCH --job-name=abyss_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate assembly

# hand over parameters for assembly algorithm
K=$1
KC=$2

# hand over file name (bam-file)
FILE_NAME=$3
SAMPLE_NAME=${FILE_NAME%.bam*}
JOB_PATH=/scratch/mnikvell/abyss_job_${SLURM_JOBID}/
IN_PATH=$4
OUT_PATH=${IN_PATH}${SAMPLE_NAME}_k${K}_kc${KC}

SINGLETONS=${SAMPLE_NAME}_singletons.fq.gz
PAIRED1=${SAMPLE_NAME}_paired1.fq.gz
PAIRED2=${SAMPLE_NAME}_paired2.fq.gz


echo "file name: ${FILE_NAME}"
echo "SAMPLE_NAME: ${SAMPLE_NAME}"
echo "JOB_PATH: ${JOB_PATH}"
echo "IN_PATH: ${IN_PATH}"
echo "OUT_PATH: ${OUT_PATH}"
echo "SINGLETONS: ${SINGLETONS}"
echo "PAIRED1: ${PAIRED1}"
echo "PAIRED2: ${PAIRED2}"



# create directories in scratch-dir
rm -rf ${JOB_PATH}
mkdir -p ${JOB_PATH}


# move fasta files to scratch-dir
cp -a -v "${IN_PATH}${SINGLETONS}" ${JOB_PATH}
cp -a -v "${IN_PATH}${PAIRED1}" ${JOB_PATH}
cp -a -v "${IN_PATH}${PAIRED2}" ${JOB_PATH}

echo "content of job dir: $(ls ${JOB_PATH})"


# move to job directory
cd ${JOB_PATH}

abyss-pe \
name=${SAMPLE_NAME}\
j=32 \
k=${K} \
kc=${KC} \
B=6G \
v=-v \
in='${PAIRED1} ${PAIRED2}' \
se=${SINGLETONS}


echo "content of dir with results: $(ls ${JOB_PATH})"

# delete fasta-files from scratch dir after assembly
rm -rf "${JOB_PATH}${SINGLETONS}"
rm -rf "${JOB_PATH}${PAIRED1}"
rm -rf "${JOB_PATH}${PAIRED2}"


# copy output back to work dir
mkdir -p "${OUT_PATH}"
cp -a "${JOB_PATH}." "${OUT_PATH}"
rm -rf ${JOB_PATH}

conda deactivate


