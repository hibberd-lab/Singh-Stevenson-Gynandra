library(tidyverse)
library(ggplot2)
library(viridis)

setwd("Fig5C_C4_pathway_data.txt")

data <- read_tsv("Line_Plot_Data")

data_g <- gather(data, key = "key", value = "value", -ID, -OG, -Species, -Colour)

data_g$key <- as.factor(factor(data_g$key, level = c("0hr", "0.5hr", "2hr", "3hr", "4hr", "24hr")))

data_g <- drop_na(data_g)

my_palette = c("#8c510a", "#01665e", "#d8b365", "#5ab4ac", "#f6e8c3", "#c7eae5")

ggplot(data_g, aes(y = value, x = key, group = ID, shape = Species, colour = Species))+
  geom_point()+
  geom_line(na.rm = T)+
  facet_wrap(~OG, scale = "free_y")+
  scale_colour_manual(values = c("#8c510a", "#01665e", "#d8b365", "#5ab4ac", "#f6e8c3", "#c7eae5"))+
  theme_bw()
  
