# install libraries
echo 'archaea'
kraken2-build --download-library archaea --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

echo 'bacteria'
kraken2-build --download-library bacteria --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

echo 'plasmid'
kraken2-build --download-library plasmid --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

echo 'viral'
kraken2-build --download-library viral --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

echo 'human'
kraken2-build --download-library human --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

echo 'fungi'
kraken2-build --download-library fungi --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

echo 'plant'
kraken2-build --download-library plant --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

echo 'protozoa'
kraken2-build --download-library protozoa --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

echo 'UniVec_Core'
kraken2-build --download-library UniVec_Core --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/


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

