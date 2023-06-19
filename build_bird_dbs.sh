#!/bin/bash



THREAD_NUM=8
DB_PATH_1=/work/mnikvell/data/Kraken2/dbs/viral_chicken_pmajor/
DB_PATH_2=/work/mnikvell/data/Kraken2/dbs/viral_5_birds/


# build db with 2 birds

kraken2-build --download-taxonomy --threads ${THREAD_NUM} --db "${DB_PATH_1}"

kraken2-build --download-library viral --db "${DB_PATH_1}"

kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_016699485.1/GCA_016699485.1_bGalGal1.mat.broiler.GRCg7b_genomic.fna --db "${DB_PATH_1}" --threads ${THREAD_NUM}

kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_001522545.3/GCA_001522545.3_Parus_major1.1_genomic.fna --db "${DB_PATH_1}" --threads ${THREAD_NUM}


kraken2-build --build --db "${DB_PATH_1}" --threads ${THREAD_NUM}

kraken2-build --clean --db "${DB_PATH_1}" --threads ${THREAD_NUM}



# build db with 5 birds

kraken2-build --download-taxonomy --threads ${THREAD_NUM} --db "${DB_PATH_2}"

kraken2-build --download-library viral --db "${DB_PATH_2}"

kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_016699485.1/GCA_016699485.1_bGalGal1.mat.broiler.GRCg7b_genomic.fna --db "${DB_PATH_2}" --threads ${THREAD_NUM}

kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_001522545.3/GCA_001522545.3_Parus_major1.1_genomic.fna --db "${DB_PATH_2}" --threads ${THREAD_NUM}

kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_002901205.1/GCA_002901205.1_cyaCae2_genomic.fna --db "${DB_PATH_2}" --threads ${THREAD_NUM}

kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_003957565.4/GCA_003957565.4_bTaeGut1.4.pri_genomic.fna --db "${DB_PATH_2}" --threads ${THREAD_NUM}

kraken2-build -add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_000331425.1/GCA_000331425.1_PseHum1.0_genomic.fna --db "${DB_PATH_2}" --threads ${THREAD_NUM}


kraken2-build --build --db "${DB_PATH_2}" --threads ${THREAD_NUM}

kraken2-build --clean --db "${DB_PATH_2}" --threads ${THREAD_NUM}


