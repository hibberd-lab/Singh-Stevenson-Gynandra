library(tidyverse)
library(gplots)

df <- read_tsv("Fig5D_heatmap_data", col_names = F)

df_matrix <- as.matrix(df[,-1])

rownames(df_matrix) <- df$X1
summary(df_matrix)

my_palette <- colorRampPalette(c("#0004ff", "#f7f7f7", "#c30000"))(n = 200)
col_breaks <- c(seq(-0.4,-0.1,length=100), seq(-0.09,0.1,length=100), seq(0.11,0.4, length=100))

heatmap.2(df_matrix, scale='none', Colv=F, cexRow=0.2, cexCol = 2, 
          trace = "none", key = TRUE, keysize = 1, breaks = col_breaks,
          key.title = NA, col=bluered, offsetCol = 0, margins = c(14,5), 
          lhei = c(1,5), lwid = c(1,2))
