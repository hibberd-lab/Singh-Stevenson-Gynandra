library(tidyverse)
library(gplots)
library(viridis)

df <- read_tsv("Fig5A_heatmap_data.txt", col_names = F)

df_matrix <- as.matrix(df[,2:5])
rownames(df_matrix) <- df$X1

col_breaks <- c(seq(-1,-0.1,length=100), seq(-0.09,0.1,length=100), seq(0.11,0.5, length=100))

svg(filename = "Fig5C.svg", height = 10, width = 5, pointsize = 20)

heatmap.2(df_matrix, Colv = F, col = viridis, RowSideColors = 
            c(rep("grey", 87), rep("black", 23)), dendrogram = "row", 
          trace = "none", symkey = F, scale = "none", breaks = col_breaks,
          cexRow = 0.4, key = T, key.title = NA, keysize = 1, lhei = c(1,5),
          lwid = c(1,2))
dev.off()
