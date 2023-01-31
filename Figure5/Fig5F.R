library(tidyverse)
library(ggplot2)

theme_set(theme_bw())
theme_update(axis.text.x = element_text(angle = 45, hjust = 1))
######################################################################
induced <- read_tsv("Fig5F_data.txt")

medians <- induced %>% group_by(Cluster) %>% summarise(median=median(log_ratio))
clusters_filtered <- medians %>% filter(median > 0.05 | median < -0.05)
clusters_filtered <- clusters_filtered[["Cluster"]]
induced <- induced[induced$Cluster %in% as.vector(clusters_filtered),]

ggplot(induced, aes(x = reorder(factor(Cluster),-log_ratio, FUN=median, desc =TRUE), y = log_ratio, group = Cluster))+
  geom_boxplot()+
  geom_hline(yintercept = 0, linetype = "dashed", colour = "grey")
