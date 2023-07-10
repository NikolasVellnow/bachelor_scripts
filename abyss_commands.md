# Commands to make de novo assembly with ABySS



## estimate bloom filter memory budget
I estimate the bloom filter memory budget to be B=30G.

## put reads without mates into separate file
sh```

conda activate samtools

samtools collate -u -@ 4 -O S1_EKDN230004350-1A_HNW2NDSX_sorted_dedup_unmapped.bam | samtools fastq -@ 4 -1 paired1.fq.gz -2 paired2.fq.gz -s singletons.fq.gz

conda activate assembly

cd S1_k80

abyss-pe name=S1 j=4 k=80 B=6G in='../paired1.fq.gz ../paired2.fq.gz' se='../singletons.fq.gz'

# verbosity level v=-v needed for bloom filter stats


```
