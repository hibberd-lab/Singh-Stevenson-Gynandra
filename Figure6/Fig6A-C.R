library(ggplot2)
library(tidyverse)
data <- read_tsv("Fig6A-D_Data")

#6A plot
data_a <- select(data, -c(MOTIF, AtC4))
data_a <- filter(data_a, GgC3 < 51)
data_a <- pivot_longer(data_a, -GgC3, values_to = "Rank")

ggplot(data_a, aes(x = GgC3, y = Rank, colour = name, shape = name))+
  geom_point()+
  theme_bw()+
  ylim(0,800)

#6B plot
data_b <- select(data, -c(MOTIF, GgC3))
data_b <- filter(data_b, AtC3 < 51)
data_b <- pivot_longer(data_b, -AtC3, values_to = "Rank")

ggplot(data_b, aes(x = AtC3, y = Rank, colour = name, shape = name))+
  geom_point()+
  ylim(0,800)+
  theme_bw()

#6C
data_c <- select(data, -c(MOTIF, GgC3, AtC3))
data_c <- filter(data_c, GgC4 < 51)
ggplot(data_c, aes(x = GgC4, y = AtC4))+
  geom_point()+
  theme_bw()
