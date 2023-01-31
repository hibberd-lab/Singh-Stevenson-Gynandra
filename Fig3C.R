#!/usr/bin/Rscript
library(ggplot2)
library(tidyverse)
library(zoo)

input <- read_tsv('Position_log2_4kbp_24hr_0m', col_names = F)

means <- input %>%
  group_by(X1) %>%
  dplyr::summarize(`24H` = mean(X2, na.rm=TRUE))

input2 <- read_tsv('Position_log2_4kbp_4hr_0m', col_names = F)

means2 <- input2 %>%
  group_by(X1) %>%
  dplyr::summarize(`4H` = mean(X2, na.rm=TRUE))

input3 <- read_tsv('Position_log2_4kbp_2hr_0m', col_names = F)

means3 <- input3 %>%
  group_by(X1) %>%
  dplyr::summarize(`2H` = mean(X2, na.rm=TRUE))

input4 <- read_tsv('Position_log2_4kbp_30m_0m', col_names = F)

means4 <- input4 %>%
  group_by(X1) %>%
  dplyr::summarize(`0.5H` = mean(X2, na.rm=TRUE))

combined <- merge(means, means2, by.x = "X1", by.y = "X1")
combined <- merge(combined, means3, by.x = "X1", by.y = "X1")
combined <- merge(combined, means4, by.x = "X1", by.y = "X1")
combined <- pivot_longer(combined, -X1)
combined <- combined %>% 
  group_by(name) %>% 
  mutate(roll_mean = rollmean(value, 100, na.pad = T))

combined$name <- factor(combined$name, levels = c("0.5H", "2H", "4H", "24H"))

ggplot(combined, aes(x = (X1/1000), y=value))+
  #geom_point(alpha = 0.1, size = 0.5)+
  ylim(-0.5, 1.5)+
  xlim(-1.9,1.9)+
  geom_hline(yintercept = 0, linetype = "dashed", colour = "#66a61e")+
  geom_vline(xintercept = 0, linetype = "dashed", colour = "red")+
  theme_bw()+
  geom_line(aes(y=roll_mean), size = 2)+
  labs(y = "log(Read Ratio)", x = "Distance From TSS (kbp)")+
  scale_color_brewer(palette = "Dark2")+
  facet_wrap(~name, nrow = 1)
