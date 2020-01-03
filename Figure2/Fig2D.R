library(ggplot2)
library(gplots)
library(tidyverse)

data <- read_tsv("Fig2D_data.txt")

data <- gather(data, key ="Timepoint", value = "value", -c(`Gg ID`, Class, `Ath Name`, `TAIR ID`))

data <- group_by(data, Class)

data$Timepoint <- factor(data$Timepoint, level = c("0hrs", "0.5hrs", "2hrs", "4hrs", "24hrs"))
data$Class <- factor(data$Class, level = c("+ve C3", "Early Up", "-ve C3", "Early Down"))

ggplot(data, aes(x = Timepoint, y = value, group = `Gg ID`))+
  geom_line(colour = "grey")+
  facet_grid(Class ~ ., scales = "free")+
  ylab("Quantil Normalised TPM/Gene Mean")+
  theme_bw()
