#!/bin/bash


# Parus major
ncbi-genome-download --section genbank vertebrate_other -A GCA_001522545.3 -F fasta,assembly-report -p 4 -r 3 -o /work/mnikvell/data/genomes/
gzip -d /work/data/genomes/genbank/vertebrate_other/GCA_001522545.3/GCA_001522545.3_Parus_major1.1_genomic.fna.gz

# Gallus gallus
ncbi-genome-download --section genbank vertebrate_other -A GCA_016699485.1 -F fasta,assembly-report -p 4 -r 3 -o /work/mnikvell/data/genomes/
gzip -d /work/data/genomes/genbank/vertebrate_other/GCA_016699485.1/GCA_016699485.1_bGalGal1.mat.broiler.GRCg7b_genomic.fna.gz

# Haemoproteus tartakovskyi
ncbi-genome-download --section genbank invertebrate -A GCA_001625125.1 -F fasta,assembly-report -p 4 -r 3 -o /work/mnikvell/data/genomes
gzip -d /work/mnikvell/data/genomes/genbank/protozoa/GCA_001625125.1/GCA_001625125.1_ASM162512v1_genomic.fna.gz 

# blue tit genome
ncbi-genome-download --section genbank vertebrate_other -A GCA_002901205.1 -F fasta,assembly-report -p 4 -r 3 -P -o /work/mnikvell/data/genomes/

# ground tit genome
ncbi-genome-download --section genbank vertebrate_other -A GCA_000331425.1 -F fasta,assembly-report -p 4 -r 3 -P -o /work/mnikvell/data/genomes/

# zebra finch genome
ncbi-genome-download --section genbank vertebrate_other -A GCA_003957565.4 -F fasta,assembly-report -p 4 -r 3 -P -o /work/mnikvell/data/genomes/


