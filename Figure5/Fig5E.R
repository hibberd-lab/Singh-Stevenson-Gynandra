library(tidyverse)
library(ggplot2)

theme_set(theme_bw())
theme_update(axis.text.x = element_text(angle = 45, hjust = 1))

################################################################################
data <- read_tsv("Fig5E_data.txt")
data <- pivot_longer(data, -Cluster)
data$name <- factor(data$name, levels = c("AtC3", "AtC4", "GgC3", "GgC4"))

data <- data %>% filter(Cluster %in% c("cluster_12", "cluster_1", "cluster_15"))
data$Cluster <- factor(data$Cluster, levels = c("cluster_12", "cluster_1", "cluster_15"))

ggplot(data, aes(x = name, y = value, group = name))+
  geom_boxplot()+
  facet_wrap(~Cluster)+
  labs(y = "Motif Enrichment  (log ratio)", x = "")+
  geom_hline(yintercept = 0, linetype = "dashed", alpha = 0.5)
