library(ggplot2)
library(readxl)
library(viridis)

path <- "~/sciebo/Bioinformatik Bachelor Bielefeld/7_SS_2023/bachelor_project/"


domains <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), 
                       sheet = "domains")

options(scipen = 999)
tapply(domains$percent_reads_rooted_clade, domains$domain, mean)
tapply(domains$percent_reads_rooted_clade, domains$domain, range)

p_domains <- ggplot(domains, aes(x = sample, y = percent_reads_rooted_clade)) +
    ggtitle("Reads classified on domain level") +
    geom_col(aes(fill = domain), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    coord_flip()
p_domains


species_in_chordata <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), 
                      sheet = "species_in_chordata")

options(scipen = 999)
tapply(species_in_chordata$percent_reads_rooted_clade, species_in_chordata$species_in_chordata, mean)
tapply(species_in_chordata$percent_reads_rooted_clade, species_in_chordata$species_in_chordata, range)


p_species_in_chordata <- ggplot(species_in_chordata,
                                aes(x = sample, y = percent_reads_rooted_clade)) +
    ggtitle("Reads classified on species level in chordata phylum") +
    geom_col(aes(fill = species_in_chordata), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    coord_flip()
p_species_in_chordata


non_metazoa_eukaryotic_phyla <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), 
                                  sheet = "non_metazoa_eukaryotic_phyla")

options(scipen = 999)
tapply(non_metazoa_eukaryotic_phyla$percent_reads_rooted_clade, 
       non_metazoa_eukaryotic_phyla$phylum_non_metazoa_eukaryotes, mean)
tapply(non_metazoa_eukaryotic_phyla$percent_reads_rooted_clade, 
       non_metazoa_eukaryotic_phyla$phylum_non_metazoa_eukaryotes, range)


p_non_metazoa_eukaryotic_phyla <- ggplot(non_metazoa_eukaryotic_phyla,
                                aes(x = sample, y = percent_reads_rooted_clade)) +
    ggtitle("Reads classified on phylum level in non-metazoan eukaryotes") +
    geom_col(aes(fill = phylum_non_metazoa_eukaryotes), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    coord_flip()
p_non_metazoa_eukaryotic_phyla


phyla_in_bacteria <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), 
                                           sheet = "phyla_in_bacteria")

options(scipen = 999)
tapply(phyla_in_bacteria$percent_reads_rooted_clade, 
       phyla_in_bacteria$phylum_bacteria, mean)
tapply(phyla_in_bacteria$percent_reads_rooted_clade, 
       phyla_in_bacteria$phylum_bacteria, range)



p_phyla_in_bacteria <- ggplot(phyla_in_bacteria,
                                         aes(x = sample, y = percent_reads_rooted_clade)) +
    ggtitle("Reads classified on phylum level in Bacteria domain") +
    geom_col(aes(fill = phylum_bacteria), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    coord_flip()
p_phyla_in_bacteria



top_5_phyla_in_bacteria <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), 
                                sheet = "top_5_phyla_in_bacteria")

options(scipen = 999)
tapply(top_5_phyla_in_bacteria$percent_reads_rooted_clade, 
       top_5_phyla_in_bacteria$top_5_phyla_bacteria, mean)
tapply(top_5_phyla_in_bacteria$percent_reads_rooted_clade, 
       top_5_phyla_in_bacteria$top_5_phyla_bacteria, range)



p_top_5_phyla_in_bacteria <- ggplot(top_5_phyla_in_bacteria,
                              aes(x = sample, y = percent_reads_rooted_clade)) +
    ggtitle("Reads classified of top 5 phyla in Bacteria domain") +
    geom_col(aes(fill = top_5_phyla_bacteria), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    coord_flip()
p_top_5_phyla_in_bacteria


top_5_phyla_in_bacteria


