#

# run kraken2 classifier
kraken2 --db /work/mnikvell/data/Kraken2/dbs/PlusPFP-16/ \
--output /work/mnikvell/data/Kraken2/outputs/output_PlusPFP_16_S1 \
--use-names \
--report /work/mnikvell/data/Kraken2/outputs/report_PlusPFP_16_S1 \
/work/mnikvell/data/subsets/S1_EKDN230004350-1A_HNW2NDSX_sorted_dedup_unmapped_subset.fasta 
