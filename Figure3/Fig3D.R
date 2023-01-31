library(tidyverse)
library(ggplot2)

theme_set(theme_bw())
theme_update(axis.text.x = element_text(angle = 45, hjust = 1))

data <- read_tsv("Fig3D_data.txt")
data <- pivot_longer(data, -Cluster)
data$name <- factor(data$name, levels = c("0.5 hours Up",	"0.5 hours Down",	"2 hours Up",	"2 hours Down",	"4 hours Up",	"4 hours Down"))
data <- filter(data, name %in% c("0.5 hours Up", "0.5 hours Down"))

ggplot(data = filter(data, Cluster == "cluster_5"), aes(x = name, y = value, group = name))+
  geom_boxplot()+
  geom_point(data = datahy5, aes(x = name, y = value), colour = "#e7298a", size = 1)+
  facet_wrap(~Cluster)+
  labs(x = "", y = "Motif Enrichment (log ratio)")+
  geom_hline(yintercept = 0, linetype = "dashed", alpha = 0.5)
