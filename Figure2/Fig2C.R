library(tidyverse)
library(gplots)
library(viridis)

df <- read_tsv("Fig2D_TF_Expression_Data.txt", col_names = F)

df_matrix <- as.matrix(df[,2:6])
rownames(df_matrix) <- df$X1
# zscore
df_matrix <- t(scale(t(df_matrix), center = T, scale = T))

heat <- heatmap.2(df_matrix, Colv = F, col = cividis, trace = "none", 
          symkey = F, scale = "none", cexRow = 0.4)
