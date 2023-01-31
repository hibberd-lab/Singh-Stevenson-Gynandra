library(tidyverse)
library(ggplot2)

theme_set(theme_bw())
theme_update(axis.text.x = element_text(angle = 45, hjust = 1))

data <- read_tsv("Fig3E_data.txt")

medians <- data %>% group_by(Cluster) %>% summarise(median=median(`log(Obs/Exp)`))
clusters_filtered <- medians %>% filter(median > 0.1 | median < -0.1)
clusters_filtered <- clusters_filtered[["Cluster"]]

data <- data[data$Cluster %in% as.vector(clusters_filtered),]

ggplot(data, aes(x = reorder(factor(Cluster),-`log(Obs/Exp)`, FUN=median, desc =TRUE), y = `log(Obs/Exp)`, group = Cluster))+
  geom_boxplot()+
  geom_hline(yintercept = 0, linetype = "dashed", alpha = 0.5)+
  labs(x = "Motif Clusters", y = "Light Specific DHS Motif Enrichment (log ratio)")
