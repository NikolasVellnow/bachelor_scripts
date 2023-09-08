library(ggplot2)
library(readxl)
library(viridis)

path <- "~/sciebo/Bioinformatik Bachelor Bielefeld/7_SS_2023/bachelor_project/"
kingdoms <- read_excel(paste(path, "kraken_taxa_percentages.xlsx", sep = ""), sheet = "kingdoms")



p <- ggplot(kingdoms, aes(x = sample, y = percent_of_reads)) +
    geom_col(aes(fill = taxon), width = 0.7) +
    scale_fill_viridis(discrete = TRUE, option = "D") +
    coord_flip()
p
