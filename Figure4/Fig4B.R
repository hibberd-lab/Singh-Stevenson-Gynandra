library(ggplot2)
library(tidyverse)

input <- read_tsv('Fig3B_DHS_TSS_data.txt', col_names = T)

ggplot(input, aes(x = Distance))+
  geom_density(aes(group = Sample, color = Sample))+
  geom_vline(xintercept=0, colour = "black")+
  xlim(-4000, 4000)
