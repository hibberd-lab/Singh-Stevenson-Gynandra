library(ggplot2)
library(tidyverse)

data <- read_tsv("Fig2B_GO_term_data.txt", 
                 col_names = c("GO_Term", "Frequency", "Time_Point", "Direction"))
data$Time_Point <- as.factor(data$Time_Point)
data$Time_Point <- ordered(data$Time_Point, levels = c("0.5", "2", "4", "24"))
data$Direction <- as.factor(data$Direction)
data$Direction <- ordered(data$Direction, levels = c("up", "down"))
data$GO_Term <- as.factor((data$GO_Term))
data$GO_Term <- ordered(data$GO_Term, levels = c("plastid", "carbohydrate metabolic process", "secondary metabolic process", 
                                                 "cellular nitrogen compound metabolic process", "lipid metabolic process", 
                                                 "response to light stimulus", "photosynthesis", "ion transport", 
                                                 "organophosphate metabolic process", "cell wall organization or biogenesis"))


ggplot(data, aes(fill = GO_Term, y = Frequency, x = Time_Point))+
  geom_bar(stat = "identity", colour = "grey")+
  scale_fill_brewer(palette = "Set3")+
  theme_bw()+
  facet_wrap(~Direction)+
  ylab("Significant GO Terms Frequency")+
  xlab("Time Point Significant Gene Set")
