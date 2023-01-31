library(tidyverse)
library(ggplot2)
library(gridExtra)
library(gplots)
library(viridis)

data_raw <- read_tsv("Fig4BC_data.txt")
######################################################################

theme_set(theme_bw())
theme_update(axis.text.x = element_text(angle = 45, hjust = 1))

data_box <- pivot_longer(data_raw, -Cluster)
data_box$name <- factor(data_box$name, levels = c("0H", "0.5H", "2H", "4H", "24H"))

ggplot(data_box, aes(x = name, y = log(value), group = name))+
  geom_boxplot(outlier.size = 1)+
  facet_wrap(~Cluster, scales = "free")+
  labs(y = "log Motif Abundance", x = "Time (hours)")