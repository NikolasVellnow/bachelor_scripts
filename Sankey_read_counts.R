library(ggplot2)
library(ggalluvial)
library(gridExtra)

path <- "~/sciebo/Bioinformatik Bachelor Bielefeld/7_SS_2023/bachelor_project/"
read_counts <- read_excel(paste(path, "sample_summary_data.xlsx", sep = ""), sheet = "read_counts")


# Create the Sankey plot:
sankey1 <- ggplot(data = read_counts,
                  aes(axis1 = sample,   # First variable on the X-axis
                      axis2 = mapping_status, # Second variable on the X-axis   # Third variable on the X-axis
                      y = num_reads)) +
    geom_alluvium(aes(fill = mapping_status)) +
    geom_stratum() +
    geom_text(stat = "stratum",
              aes(label = after_stat(stratum))) +
    scale_fill_viridis_d() +
    theme_void()
sankey1

S1 <- read_counts[read_counts$sample=="S1",]

sankey2 <- ggplot(data = S1,
                  aes(axis1 = sample,   # First variable on the X-axis
                      axis2 = mapping_status, # Second variable on the X-axis   # Third variable on the X-axis
                      y = num_reads)) +
    geom_alluvium(aes(fill = mapping_status)) +
    geom_stratum() +
    geom_text(stat = "stratum",
              aes(label = after_stat(stratum))) +
    scale_fill_viridis_d() +
    theme_void()
sankey2


s4 <- read_counts[read_counts$sample=="s4",]

sankey3 <- ggplot(data = s4,
                  aes(axis1 = sample,   # First variable on the X-axis
                      axis2 = mapping_status, # Second variable on the X-axis   # Third variable on the X-axis
                      y = num_reads)) +
    geom_alluvium(aes(fill = mapping_status)) +
    geom_stratum() +
    geom_text(stat = "stratum",
              aes(label = after_stat(stratum))) +
    scale_fill_viridis_d() +
    theme_void()
sankey3


s20 <- read_counts[read_counts$sample=="s20",]

sankey4 <- ggplot(data = s20,
                  aes(axis1 = sample,   # First variable on the X-axis
                      axis2 = mapping_status, # Second variable on the X-axis   # Third variable on the X-axis
                      y = num_reads)) +
    geom_alluvium(aes(fill = mapping_status)) +
    geom_stratum() +
    geom_text(stat = "stratum",
              aes(label = after_stat(stratum))) +
    scale_fill_viridis_d() +
    theme_void()
sankey4


SRR <- read_counts[read_counts$sample=="SRR5423301",]

sankey5 <- ggplot(data = SRR,
                  aes(axis1 = sample,   # First variable on the X-axis
                      axis2 = mapping_status, # Second variable on the X-axis   # Third variable on the X-axis
                      y = num_reads)) +
    geom_alluvium(aes(fill = mapping_status)) +
    geom_stratum() +
    geom_text(stat = "stratum",
              aes(label = after_stat(stratum))) +
    scale_fill_viridis_d() +
    theme_void()
sankey5


grid.arrange(sankey2, sankey3, sankey4, sankey5, nrow=4, ncol=1)
