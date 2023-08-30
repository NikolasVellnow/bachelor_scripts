library(ggplot2)
library(gridExtra)

path <- "~/sciebo/Bioinformatik Bachelor Bielefeld/7_SS_2023/bachelor_project/outputs/abyss_assemblies/s20_EKDN230004369-1A_HNHMFDSX_sorted_dedup_unmapped_k85_kc2/"

s20_lengths <- read.table(paste(path, "s20_unmapped_assembly_lengths.txt", sep = ""), quote="\"", comment.char="")

p1 <- ggplot(s20_lengths, aes(x=V1)) +
    scale_y_log10(limits=c(NA,10300)) +
    labs(title="s20",x="unitigs length (bases)", y = "Count")+
    xlim(c(0,1200)) +
    theme_bw() +
    geom_histogram(binwidth=20,
                   color="black",
                   fill="grey")
p1


path <- "~/sciebo/Bioinformatik Bachelor Bielefeld/7_SS_2023/bachelor_project/outputs/abyss_assemblies/SRR5423301_sorted_dedup_unmapped_k85_kc2/"

SRR_lengths <- read.table(paste(path, "SRR5423301_unmapped_assembly_lengths.txt", sep = ""), quote="\"", comment.char="")

p2 <- ggplot(SRR_lengths, aes(x=V1)) +
    scale_y_log10(limits=c(NA,10300)) +
    labs(title="reference bird",x="unitigs length (bases)", y = "Count")+
    xlim(c(0,1200)) +
    theme_bw() +
    geom_histogram(binwidth=20,
                   color="black",
                   fill="grey")
p2

grid.arrange(p1, p2, nrow=2, ncol=1)

