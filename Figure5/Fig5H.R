library(ggplot2)
library(ggfortify)
library(tidyverse)
library(viridis)
library(plyr)
library(data.table)

data <- read_tsv("Motif_Cluster_Proportion_Data2", col_names = T)

data_pivot <- pivot_longer(data, cols = ends_with("hr"), names_to = "TimeCourse", values_to = "Freq", values_drop_na = T)

data_pivot$Set <- as.factor(factor(data_pivot$Set, level = c("AtC3", "GgC3", "AtC4", "GgC4")))
data_pivot$TimeCourse <- as.factor(factor(data_pivot$TimeCourse, level = c("0hr", "0.5hr", "2hr", "3hr", "4hr", "24hr")))

data_pivot <- data.table(data_pivot)

data_pivot[, Freq := as.numeric(sub('%$', '', Freq))]
data_pivot[!is.na(Freq), Cumulative.Sum := cumsum(Freq), by = c('Cluster', 'Set')]

ggplot(data_pivot, aes(x = TimeCourse, y = Cumulative.Sum, colour = Set))+
  geom_line(aes(group = Set), alpha = 0.6)+
  geom_point(size = 0.3)+
  facet_wrap(~Cluster, scales = "free_y")+
  theme_bw()
