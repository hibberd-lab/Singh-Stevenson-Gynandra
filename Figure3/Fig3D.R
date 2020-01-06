library(tidyverse)
library(ggplot2)
library(reshape2)

df <- read_tsv("Fig3D_dDHS_data.txt", col_names = c("DHS", "30min_change", "2H_change", "4H_change", "24H_change", "Class"))

data_m <- gather(df, key = "Time", value = "dDHS", -DHS, -Class)
data_m$Time <- factor(data_m$Time, levels = c("30min_change", "2H_change","4H_change", "24H_change"))

df_matrix <- as.matrix(df[,2:5])
rownames(df_matrix) <- df$DHS

ggplot(data_m, aes(x = Time, y = dDHS)) +
  geom_violin(aes(fill = Time), draw_quantiles = c(0.5), alpha = 0.4)+
  facet_wrap(~Class)+
  ylim(c(-20, 25))+
  geom_jitter(width = 0.1, alpha = 0.5)+
  theme_bw()
