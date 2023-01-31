library(ggplot2)
library(tidyverse)

data <- read_tsv("Fig2E_data.txt")
data_scaled <- as_tibble(t(scale(t(data[2:7]), center = T, scale = T)))
data_scaled$ID <- data$ID
data_scaled$Sp <- data$Sp
data_long <- pivot_longer(data_scaled, -c(ID, Sp))
data_long$name <- factor(data_long$name, levels = c("0hrs", "0.5hrs", "2hrs", "3hrs", "4hrs", "24hrs"))

ggplot(data_long, aes(x = name, y = value, fill = Sp))+
  geom_boxplot(alpha = 0.5)+
  scale_fill_brewer(palette = "Dark2")+
  ylab("Zscore")+
  xlab("Time Point")+
  theme_bw()

data <- read_tsv("Fig2F_data.txt")
data_scaled <- as_tibble(t(scale(t(data[2:7]), center = T, scale = T)))
data_scaled$ID <- data$ID
data_scaled$Sp <- data$Sp
data_long <- pivot_longer(data_scaled, -c(ID, Sp))
data_long$name <- factor(data_long$name, levels = c("0hrs", "0.5hrs", "2hrs", "3hrs", "4hrs", "24hrs"))

ggplot(data_long, aes(x = name, y = value, fill = Sp))+
  geom_boxplot(alpha = 0.5)+
  scale_fill_brewer(palette = "Dark2")+
  ylab("Zscore")+
  xlab("Time Point")+
  theme_bw()
