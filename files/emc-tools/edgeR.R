library(edgeR)
bcv <- 0.2

files = c("control.txt", "treat.txt")
RG <- readDGE(files)
bcv <- 0.2

y <- DGEList(counts=RG, group=1:2)
et <- exactTest(y, dispersion=bcv^2)
#estimateDisp(y, robust=TRUE)

# Remove pvalue column
et$table = subset(et$table, select = -PValue)
# Add deg colum with true/false
et$table$deg = abs(et$table$logFC) >= 2
#write.table(et$table, file="edger.tsv", quote=FALSE, sep="\t")
write.table(data.frame("Gene"=rownames(et$table),et$table),"edger.tsv", row.names=FALSE, sep="\t", quote=FALSE)
