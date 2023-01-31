library(ggplot2)
library(tidyverse)

data <- read_tsv("Fig4A_data.txt")
data <- pivot_longer(data, -Feature)
data$name <- factor(data$name, levels = c("0 hours", "0.5 hours", "2 hours", "4 hours", "24 hours"))
data$Feature <- factor(data$Feature, levels = c("Intergenic","3UTR", "Intron", "Exon", "5UTR", "Promoter"))

ggplot(data, aes(x = "", y=value, fill=Feature))+
  geom_bar(width = 1, stat = "identity", position = position_fill())+
  coord_polar("y", start=0)+
  facet_wrap(~name)+
  theme_bw()+
  labs(x = "", y = "")+
  scale_fill_brewer(palette = "Dark2")

