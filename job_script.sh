#!/bin/bash -l
#SBATCH --partition=short
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --time=02:00:00 
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=12G
#SBATCH --job-name=kraken_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

conda activate kraken

# create directories in scratch-dir
mkdir /scratch/mnikvell/kraken_job/
mkdir /scratch/mnikvell/kraken_job/PlusPF-8
mkdir /scratch/mnikvell/kraken_job/kraken_outputs

# move database to scratch-dir
mv /work/mnikvell/data/Kraken2/dbs/PlusPF-8 /scratch/mnikvell/kraken_job/



