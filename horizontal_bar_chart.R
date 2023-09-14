library(ggplot2)
library(readxl)
library(viridis)
library(plyr)

path <- "~/sciebo/Bioinformatik Bachelor Bielefeld/7_SS_2023/bachelor_project/"


sample_order <- rev(c(
    'S1',
    'S2',
    's3',
    's4',
    's5',
    's6',
    's7',
    's8',
    's9',
    's10',
    's11',
    's12',
    's13',
    's14',
    's15',
    's16',
    's17',
    's18',
    's19',
    's20',
    'SRR5423301'
))

label_pos <- rep(115,21) # customize where absolute numbers should go in plot

############# Domains ###############################

domains <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), 
                       sheet = "domains")

domains$sample <- factor(domains$sample,
                         levels = sample_order,
                         ordered=T)

domains$sample <- revalue(domains$sample, c(
    "SRR5423301"="blood sample"
))

options(scipen = 999)
tapply(domains$percent_reads_rooted_clade, domains$domain, mean)
tapply(domains$percent_reads_rooted_clade, domains$domain, range)

p_domains <- ggplot(domains, aes(x = sample, y = percent_reads_rooted_clade)) +
    geom_col(aes(fill = domain), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    geom_text(data=domains[domains$domain=='Archaea',], 
              aes(label = num_total_reads, y=label_pos, hjust=1),
              size=3.2) +
    expand_limits(y=110) +
    scale_y_continuous(breaks=c(0,25,50,75,100)) +
    coord_flip() +
    labs(x = "Sample", y = "Percent of reads", fill = "Domain")
p_domains


ggsave(file="domains_in_all_reads.pdf",plot=p_domains,path=paste(path, "plots", sep = ""))


############# Species in Chordata ###############################

species_in_chordata <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), 
                      sheet = "species_in_chordata")

species_in_chordata$sample <- factor(species_in_chordata$sample,
                         levels = sample_order,
                         ordered=T)

# rename levels
species_in_chordata$species_in_chordata <- revalue(species_in_chordata$species_in_chordata, c(
    "Cyanistes caeruleus"="C. caeruleus",
    "Gallus gallus"="G. gallus",
    "Homo sapiens"="H. sapiens",
    "Parus major"="P. major",
    "Pseudopodoces humilis"="P. humilis",
    "Taeniopygia guttata"="T. guttata",
    "unclassified_at_species_level"="unclassified"
))

species_in_chordata$sample <- revalue(species_in_chordata$sample, c(
    "SRR5423301"="blood sample"
))


options(scipen = 999)
tapply(species_in_chordata$percent_reads_rooted_clade, species_in_chordata$species_in_chordata, mean)
tapply(species_in_chordata$percent_reads_rooted_clade, species_in_chordata$species_in_chordata, range)


p_species_in_chordata <- ggplot(species_in_chordata,
                                aes(x = sample, y = percent_reads_rooted_clade)) +
    #ggtitle("Reads classified on species level in chordata phylum") +
    geom_col(aes(fill = species_in_chordata), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    geom_text(data=species_in_chordata[species_in_chordata$species_in_chordata=='P. major',], 
              aes(label = num_total_reads, y=label_pos, hjust=1),
              size=3.2) +
    expand_limits(y=110) +
    scale_y_continuous(breaks=c(0,25,50,75,100)) +
    coord_flip() +
    labs(x = "Sample", y = "Percent of reads", fill = "Species")
p_species_in_chordata


ggsave(file="species_in_chordata.pdf",plot=p_species_in_chordata,path=paste(path, "plots", sep = ""))



############# Non-metazoa eukaryotic phyla ###############################

non_metazoa_eukaryotic_phyla <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), 
                                  sheet = "non_metazoa_eukaryotic_phyla")

non_metazoa_eukaryotic_phyla$sample <- factor(non_metazoa_eukaryotic_phyla$sample,
                                     levels = sample_order,
                                     ordered=T)

# rename levels
non_metazoa_eukaryotic_phyla$sample <- revalue(non_metazoa_eukaryotic_phyla$sample, c(
    "SRR5423301"="blood sample"
))

options(scipen = 999)
tapply(non_metazoa_eukaryotic_phyla$percent_reads_rooted_clade, 
       non_metazoa_eukaryotic_phyla$phylum_non_metazoa_eukaryotes, mean)
tapply(non_metazoa_eukaryotic_phyla$percent_reads_rooted_clade, 
       non_metazoa_eukaryotic_phyla$phylum_non_metazoa_eukaryotes, range)


p_non_metazoa_eukaryotic_phyla <- ggplot(non_metazoa_eukaryotic_phyla,
                                aes(x = sample, y = percent_reads_rooted_clade)) +
    # ggtitle("Reads classified on phylum level in non-metazoan eukaryotes") +
    geom_col(aes(fill = phylum_non_metazoa_eukaryotes), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    geom_text(data=non_metazoa_eukaryotic_phyla[non_metazoa_eukaryotic_phyla$phylum_non_metazoa_eukaryotes=='Apicomplexa',], 
              aes(label = num_total_reads, y=label_pos, hjust=1),
              size=3.2) +
    expand_limits(y=110) +
    scale_y_continuous(breaks=c(0,25,50,75,100)) +
    coord_flip() +
    labs(x = "Sample", y = "Percent of reads", fill = "Phylum")
p_non_metazoa_eukaryotic_phyla


ggsave(file="phyla_non_metazoan_eukaryotes.pdf",
       plot=p_non_metazoa_eukaryotic_phyla,
       path=paste(path, "plots", sep = "")
)


############# Phyla in Bacteria ###############################

phyla_in_bacteria <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), 
                                           sheet = "phyla_in_bacteria")


phyla_in_bacteria$sample <- factor(phyla_in_bacteria$sample,
                                              levels = sample_order,
                                              ordered=T)

# rename levels
phyla_in_bacteria$sample <- revalue(phyla_in_bacteria$sample, c(
    "SRR5423301"="blood sample"
))

options(scipen = 999)
tapply(phyla_in_bacteria$percent_reads_rooted_clade, 
       phyla_in_bacteria$phylum_bacteria, mean)
tapply(phyla_in_bacteria$percent_reads_rooted_clade, 
       phyla_in_bacteria$phylum_bacteria, range)



p_phyla_in_bacteria <- ggplot(phyla_in_bacteria,
                                         aes(x = sample, y = percent_reads_rooted_clade)) +
    #ggtitle("Reads classified on phylum level in Bacteria domain") +
    geom_col(aes(fill = phylum_bacteria), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    geom_text(data=phyla_in_bacteria[phyla_in_bacteria$phylum_bacteria=='Bacillota',], 
              aes(label = num_total_reads, y=label_pos, hjust=1),
              size=3.2) +
    expand_limits(y=110) +
    scale_y_continuous(breaks=c(0,25,50,75,100)) +
    coord_flip() +
    labs(x = "Sample", y = "Percent of reads", fill = "Phylum")
p_phyla_in_bacteria

ggsave(file="phyla_in_bacteria.pdf",
       plot=p_phyla_in_bacteria,
       path=paste(path, "plots", sep = "") #,width=6, height=3.69
)



############# Top 5 phyla in Bacteria ###############################

top_5_phyla_in_bacteria <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), 
                                sheet = "top_5_phyla_in_bacteria")

top_5_phyla_in_bacteria$sample <- factor(top_5_phyla_in_bacteria$sample,
                                   levels = sample_order,
                                   ordered=T)

# rename levels
top_5_phyla_in_bacteria$sample <- revalue(top_5_phyla_in_bacteria$sample, c(
    "SRR5423301"="blood sample"
))

options(scipen = 999)
tapply(top_5_phyla_in_bacteria$percent_reads_rooted_clade, 
       top_5_phyla_in_bacteria$top_5_phyla_bacteria, mean)
tapply(top_5_phyla_in_bacteria$percent_reads_rooted_clade, 
       top_5_phyla_in_bacteria$top_5_phyla_bacteria, range)


p_top_5_phyla_in_bacteria <- ggplot(top_5_phyla_in_bacteria,
                              aes(x = sample, y = percent_reads_rooted_clade)) +
    #ggtitle("Reads classified of top 5 phyla in Bacteria domain") +
    geom_col(aes(fill = top_5_phyla_bacteria), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    geom_text(data=top_5_phyla_in_bacteria[top_5_phyla_in_bacteria$top_5_phyla_bacteria=='Bacteroidota',], 
              aes(label = num_total_reads, y=label_pos, hjust=1),
              size=3.2) +
    expand_limits(y=110) +
    scale_y_continuous(breaks=c(0,25,50,75,100)) +
    coord_flip() +
    labs(x = "Sample", y = "Percent of reads", fill = "Phylum")
p_top_5_phyla_in_bacteria


ggsave(file="top_5_phyla_in_bacteria.pdf",
       plot=p_top_5_phyla_in_bacteria,
       path=paste(path, "plots", sep = "") #,width=6, height=3.69
)


