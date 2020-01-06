library(edgeR)

data <- read.table('All_read_counts.txt')
head(data)
group <- c(1,1,1,2,2,2,3,3,3,4,4,4,5,5,5)
y <- DGEList(counts=data, group=group)
y$samples
keep <- rowSums(cpm(y)>1) >= 2
y <- y[keep, , keep.lib.sizes=FALSE]
head(y)
y <- calcNormFactors(y)
y$samples
design <- model.matrix(~group)
y <- estimateDisp(y, design)
group <- factor(c(1,1,1,2,2,2,3,3,3,4,4,4,5,5,5))
design <- model.matrix(~group)
fit <- glmQLFit(y, design)
qlf.2vs1 <- glmQLFTest(fit, coef=2)
qlf.3vs2 <- glmQLFTest(fit, coef=3:2)
qlf.4vs3 <- glmQLFTest(fit, coef=4:3)
qlf.5vs4 <- glmQLFTest(fit, coef=5:4)
write.table(qlf.2vs1$table, "0.5H_vs_0H", sep="\t")
write.table(qlf.3vs2$table, "2H_vs_0.5H", sep="\t")
write.table(qlf.4vs3$table, "4H_vs_2H", sep="\t")
write.table(qlf.5vs4$table, "24H_vs_4H", sep="\t")
