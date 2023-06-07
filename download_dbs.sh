#!/bin/bash


echo 'taxonomy'
kraken2-build --download-taxonomy --threads 3 --db /work/mnikvell/data/Kraken2/dbs/full/

echo 'archaea'
kraken2-build --download-library archaea --threads 3 --db /work/mnikvell/data/Kraken2/dbs/full/

echo 'bacteria'
kraken2-build --download-library bacteria --threads 3 --db /work/mnikvell/data/Kraken2/dbs/full/

echo 'plasmid'
kraken2-build --download-library plasmid --threads 3 --db /work/mnikvell/data/Kraken2/dbs/full/

echo 'viral'
kraken2-build --download-library viral --threads 3 --db /work/mnikvell/data/Kraken2/dbs/full/

echo 'human'
kraken2-build --download-library human --threads 3 --db /work/mnikvell/data/Kraken2/dbs/full/

echo 'fungi'
kraken2-build --download-library fungi --threads 3 --db /work/mnikvell/data/Kraken2/dbs/full/

echo 'plant'
kraken2-build --download-library plant --threads 3 --db /work/mnikvell/data/Kraken2/dbs/full/

echo 'protozoa'
kraken2-build --download-library protozoa --threads 3 --db /work/mnikvell/data/Kraken2/dbs/full/

echo 'UniVec_Core'
kraken2-build --download-library UniVec_Core --threads 3 --db /work/mnikvell/data/Kraken2/dbs/full/

