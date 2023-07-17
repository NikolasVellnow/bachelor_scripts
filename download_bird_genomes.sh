#!/bin/bash




# blue tit genome
ncbi-genome-download --section genbank vertebrate_other -A GCA_002901205.1 -F fasta,assembly-report -p 4 -r 3 -P -o /work/mnikvell/data/genomes/

# ground tit genome
ncbi-genome-download --section genbank vertebrate_other -A GCA_000331425.1 -F fasta,assembly-report -p 4 -r 3 -P -o /work/mnikvell/data/genomes/

# zebra finch genome
ncbi-genome-download --section genbank vertebrate_other -A GCA_003957565.4 -F fasta,assembly-report -p 4 -r 3 -P -o /work/mnikvell/data/genomes/


