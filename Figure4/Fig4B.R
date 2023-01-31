library(tidyverse)
library(ggplot2)
library(gridExtra)
library(gplots)
library(viridis)

data_raw <- read_tsv("Fig4BC_data.txt")
######################################################################

theme_set(theme_bw())
theme_update(axis.text.x = element_text(angle = 45, hjust = 1))

data_box <- pivot_longer(data_raw, -Cluster)
data_box$name <- factor(data_box$name, levels = c("0H", "0.5H", "2H", "4H", "24H"))

data_box <- filter(data_box, Cluster %in% c("cluster_1", "cluster_20", "cluster_26", "cluster_3", "cluster_12", "cluster_21",
                                            "cluster_22", "cluster_13",
                                            "cluster_18", "cluster_28", "cluster_31", "cluster_24", "cluster_25", "cluster_17", 
                                            "cluster_27", "cluster_19", "cluster_32", "cluster_9", 
                                            "cluster_5", "cluster_15", 
                                            "cluster_7", 
                                            "cluster_8"))
data_box$Cluster <- factor(data_box$Cluster, levels = c("cluster_1", "cluster_20", "cluster_26", "cluster_3", "cluster_12", "cluster_21",
                                                        "cluster_22", "cluster_13",
                                                        "cluster_18", "cluster_28", "cluster_31", "cluster_24", "cluster_25", "cluster_17", 
                                                        "cluster_27", "cluster_19", "cluster_32", "cluster_9", 
                                                        "cluster_5", "cluster_15", 
                                                        "cluster_7", 
                                                        "cluster_8"))

######################################################################
medians <- pivot_longer(data_raw, -Cluster) %>% group_by(Cluster, name) %>% summarise(median=median(value))
medians <- pivot_wider(medians, names_from = "name", values_from = "median")
medians <- as_tibble(t(scale(t(medians[2:6]), scale = F)))

plot_scatter <- function(data, x, y, xlab, ylab, title) {
    theme_update(plot.title = element_text(size = 6),
                 axis.title = element_text(size = 6),
                 axis.text = element_text(size = 4))
    p <- ggplot(data, aes(x = x, y = y))+
        geom_point()+
        geom_vline(xintercept = 0, linetype = "dashed", alpha = 0.3)+
        geom_hline(yintercept = 0, linetype = "dashed", alpha = 0.3)+
        labs(x = xlab, y = ylab)+
        geom_smooth(method='lm', alpha = 0.2)+
        ggtitle(title)
}

svg("Fig4B.svg", width = 4, height = 4)
a <- plot_scatter(data = medians, x = medians$`0H`, y = medians$`0.5H`, "0 hours", "0.5 hours", 
                  "Motif Abundance in DGF at 0.5 vs 0 hours")
b <- plot_scatter(data = medians, x = medians$`0H`, y = medians$`2H`, "0 hours", "2 hours", 
                  "Motif Abundance in DGF at 2 vs 0 hours")
c <- plot_scatter(data = medians, x = medians$`0H`, y = medians$`4H`, "0 hours", "4 hours", 
                  "Motif Abundance in DGF at 4 vs 0 hours")
d <- plot_scatter(data = medians, x = medians$`0H`, y = medians$`24H`, "0 hours", "24 hours", 
                  "Motif Abundance in DGF at 24 vs 0 hours")
grid.arrange(a, b, c, d, nrow=2)
dev.off()

