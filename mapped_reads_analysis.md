# Analysis of mapped P. major reads

## Aims


## Creating index files
```sh
#!/bin/bash

# activate conda environment with samtools
conda activate samtools

# create index files for bams
for file in *.bam
do
	samtools index $file
done

# deactivate samtools environment
conda deactivate

```
## Subsetting of bam files
Subset bam files with `subset_bams.sh` script:
```sh
#!/bin/bash

conda activate samtools

mkdir subsets

for file in *.bam
do	
	FILENAME="$file"
	FILENAME=${FILENAME%.bam*}
	echo $FILENAME
	samtools view -bo "$FILENAME"_subset.bam -s 123.001 "$file"
done

conda deactivate

# move subset-bams into the subset directory
mv *_subset.bam subsets/
```

## Create textfile with coverages of bams

```sh
samtools depth -a -H -f bam_file_list.txt > coverage_S1_s4_s20.txt
```


## Look at file sizes and raw data more generally

### Count number of reads in bam files
I counted the number of reads in the bam files with the shell-script `num_reads_bams.sh`:

```sh
#!/bin/bash

touch num_reads.txt

for file in *.bam
do	
	printf '%s\t%s\n' $file $(samtools view -c $file)

done > num_reads.txt

```

# Distribution of read lengths


```sh
# get counts (2. column) of read of different length (1. column)
samtools stats S1_EKDN230004350-1A_HNW2NDSX_sorted_dedup_unmapped_subset.bam | grep ^RL | cut -f 2-

```


## Kraken2 analysis


```sh

## Download additional genomes

# Parus major
ncbi-genome-download --section genbank vertebrate_other -A GCA_001522545.3 -F fasta,assembly-report -p 4 -r 3 -o /work/mnikvell/data/genomes/
gzip -d /work/data/genomes/genbank/vertebrate_other/GCA_001522545.3/GCA_001522545.3_Parus_major1.1_genomic.fna

# Gallus gallus
ncbi-genome-download --section genbank vertebrate_other -A GCA_016699485.1 -F fasta,assembly-report -p 4 -r 3 -o /work/mnikvell/data/genomes/
gzip -d /work/data/genomes/genbank/vertebrate_other/GCA_016699485.1/GCA_016699485.1_bGalGal1.mat.broiler.GRCg7b_genomic.fna

# Haemoproteus tartakovskyi
ncbi-genome-download --section genbank invertebrate -A GCA_001625125.1 -F fasta,assembly-report -p 4 -r 3 -o /work/mnikvell/data/genomes
gzip -d /work/mnikvell/data/genomes/genbank/protozoa/GCA_001625125.1/GCA_001625125.1_ASM162512v1_genomic.fna.gz 

```



### Shell script to install libraries and add genomes

TODO

```sh
## Install taxonomy
kraken2-build --download-taxonomy --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

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

## add genomes to library

# great tit
kraken2-build --add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_001522545.3/GCA_001522545.3_Parus_major1.1_genomic.fna \
--db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

# chicken
kraken2-build --add-to-library /work/mnikvell/data/genomes/genbank/vertebrate_other/GCA_016699485.1/GCA_016699485.1_bGalGal1.mat.broiler.GRCg7b_genomic.fna \
--db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

# blood parasite
kraken2-build --add-to-library /work/mnikvell/data/genomes/genbank/protozoa/GCA_001625125.1/GCA_001625125.1_ASM162512v1_genomic.fna \
--db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/

```

### Shell script to build database
TODO
```sh

kraken2-build --build --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16_birds/ --threads 12



```


### Shell script to build database
TODO
```sh

kraken2 --db /work/mnikvell/data/Kraken2/dbs/EuPathDB46 --output /work/mnikvell/data/Kraken2/outputs/output_EuPathDB46_S1 --use-names --report /work/mnikvell/data/Kraken2/outputs/report_EuPathDB46_S1 /work/mnikvell/data/subsets/S1_EKDN230004350-1A_HNW2NDSX_sorted_dedup_unmapped_subset.fasta 




```



