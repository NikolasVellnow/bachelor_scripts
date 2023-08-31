library(ggplot2)
library(gridExtra)

# S1
path <- "~/sciebo/Bioinformatik Bachelor Bielefeld/7_SS_2023/bachelor_project/outputs/abyss_assemblies/S1_EKDN230004350-1A_HNW2NDSX_sorted_dedup_unmapped_k85_kc2/"
S1_lengths <- read.table(paste(path, "S1_unmapped_assembly_lengths.txt", sep = ""), quote="\"", comment.char="")

summary(S1_lengths)

p_S1 <- ggplot(S1_lengths, aes(x=V1)) +
    scale_y_log10(limits=c(NA,10300)) +
    labs(title="S1",x="unitigs length (bases)", y = "Count")+
    #xlim(c(0,1400)) +
    scale_x_continuous(limits=c(0,1400), breaks=seq(0,1401,200)) +
    theme_bw() +
    geom_histogram(binwidth=20,
                   color="black",
                   fill="grey")
p_S1


path <- "~/sciebo/Bioinformatik Bachelor Bielefeld/7_SS_2023/bachelor_project/outputs/abyss_assemblies/s4_EKDN230004353-1A_HNHMFDSX5_L3_sorted_dedup_unmapped_k85_kc2/"
s4_lengths <- read.table(paste(path, "s4_unmapped_assembly_lengths.txt", sep = ""), quote="\"", comment.char="")

summary(s4_lengths)

p_s4 <- ggplot(SRR_lengths, aes(x=V1)) +
    scale_y_log10(limits=c(NA,10300)) +
    labs(title="s4",x="unitigs length (bases)", y = "Count")+
    scale_x_continuous(limits=c(0,1400), breaks=seq(0,1401,200)) +
    theme_bw() +
    geom_histogram(binwidth=20,
                   color="black",
                   fill="grey")
p_s4


path <- "~/sciebo/Bioinformatik Bachelor Bielefeld/7_SS_2023/bachelor_project/outputs/abyss_assemblies/s20_EKDN230004369-1A_HNHMFDSX_sorted_dedup_unmapped_k85_kc2/"

s20_lengths <- read.table(paste(path, "s20_unmapped_assembly_lengths.txt", sep = ""), quote="\"", comment.char="")

summary(s20_lengths)

p_s20 <- ggplot(s20_lengths, aes(x=V1)) +
    scale_y_log10(limits=c(NA,10300)) +
    labs(title="s20",x="unitigs length (bases)", y = "Count")+
    scale_x_continuous(limits=c(0,1400), breaks=seq(0,1401,200)) +
    theme_bw() +
    geom_histogram(binwidth=20,
                   color="black",
                   fill="grey")
p_s20


path <- "~/sciebo/Bioinformatik Bachelor Bielefeld/7_SS_2023/bachelor_project/outputs/abyss_assemblies/SRR5423301_sorted_dedup_unmapped_k85_kc2/"

SRR_lengths <- read.table(paste(path, "SRR5423301_unmapped_assembly_lengths.txt", sep = ""), quote="\"", comment.char="")

summary(SRR_lengths)

p_SRR <- ggplot(SRR_lengths, aes(x=V1)) +
    scale_y_log10(limits=c(NA,10300)) +
    labs(title="reference bird",x="unitigs length (bases)", y = "Count")+
    scale_x_continuous(limits=c(0,1400), breaks=seq(0,1401,200)) +
    theme_bw() +
    geom_histogram(binwidth=20,
                   color="black",
                   fill="grey")
p_SRR

grid.arrange(p_S1, p_s4, p_s20, p_SRR, nrow=4, ncol=1)

