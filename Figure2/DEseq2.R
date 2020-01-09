library(DESeq2)

#read in the counts data
txi <- read.delim("All_read_counts.txt",header=T, sep="\t")
counts <- txi[,-1]
row.names(counts)<- txi$X
#create the sample to condition table
sampleTable <- data.frame(condition = factor(c(rep("0",3), rep("30", 3), rep("2H", 3),rep("4H", 3), rep("24H", 3))))
row.names(sampleTable)<- c("X0_1","X0_2","X0_3","X30_1","X30_2","X30_3","X2H_1","X2H_2","X2H_3","X4H_1","X4H_2","X4H_3","X24H_1","X24H_2","X24H_3")
#convert to matrix
counts <- as.matrix(counts)
counts <- round(counts)
#check true
all(rownames(sampleTable) == colnames(counts))
#create the dds object and filter low expressed (same as edgeR)
dds <- DESeqDataSetFromMatrix(counts, sampleTable, ~condition)
dds <- dds[ rowSums(counts(dds)) > 2, ]

dds <- DESeq(dds)
# extract comparison to previous time point
res.30vs0 <- results(dds, contrast=c("condition","30","0"))
res.2Hvs30 <- results(dds, contrast=c("condition","2H","30"))
res.4Hvs2H <- results(dds, contrast=c("condition","4H","2H"))
res.24Hvs4H <- results(dds, contrast=c("condition","24H","4H"))
summary(res.30vs0)
summary(res.2Hvs30)
summary(res.4Hvs2H)
summary(res.24Hvs4H)
write.csv(res.30vs0,"DESeq2-30vs0.csv")
write.csv(res.2Hvs30,"DESeq2-2Hvs30.csv")
write.csv(res.4Hvs2H,"DESeq2-4Hvs2H.csv")
write.csv(res.24Hvs4H,"DESeq2-24Hvs4H.csv")

#make PCA plot
vsd <- vst(dds, blind=FALSE)
plotPCA(vsd, intgroup=c("condition"))

pcaData <- plotPCA(vsd, intgroup = c( "condition"), returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
ggplot(pcaData, aes(x = PC1, y = PC2, color = condition, shape = condition)) +
  geom_point(size =3) +
  xlab(paste0("PC1: ", percentVar[1], "% variance")) +
  ylab(paste0("PC2: ", percentVar[2], "% variance")) +
  coord_fixed()
