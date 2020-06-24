library(tidyverse)
library(gplots)
library(viridis)

df <- read_tsv("Fig6D_motif_rank_data.txt", col_names = c("Motif","AtC3", "GgC3", "AtC4", "GgC4"))

df_matrix <- as.matrix(df[,-1])

rownames(df_matrix) <- df$Motif

col_breaks <- c(seq(1,50,length=300), seq(51,300,length=300), seq(301,841, length=300))

svg(filename = "Fig6D.svg", height = 10, width = 5, pointsize = 12)

heatmap.2(df_matrix, scale='none', Colv=F, cexRow=0.9, cexCol = 2, 
          trace = "none", key = TRUE, keysize = 1, key.title = NA, 
          col=cividis, offsetCol = 0, margins = c(14,9), breaks = col_breaks,
          lhei = c(1,5), lwid = c(1,2))
dev.off()
