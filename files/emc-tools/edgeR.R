library(edgeR)
bcv <- 0.2

args <- commandArgs(trailingOnly = TRUE)
should_filter <- args[1] == "TRUE"

files = dir(pattern='*.txt')
split_ctrl_trt <- sapply(strsplit(files, "-"), function(x) x[1])

dge <- readDGE(files, group=factor(split_ctrl_trt))
print(head(dge))

keep <- filterByExpr(y = dge)
dge <- dge[keep, , keep.lib.sizes=FALSE]
dge <- calcNormFactors(object = dge)
print(head(dge))

# Does not work for us!
# dge <- estimateDisp(y = dge)

bcv <- 0.2
y <- DGEList(counts=dge, group=factor(split_ctrl_trt))
et <- exactTest(y, dispersion=bcv^2)
print(head(et))

summary(decideTests(object = et, lfc = 1))
#estimateDisp(y, robust=TRUE)

# Remove pvalue column
et$table = subset(et$table, select = -PValue)
# Add deg colum with true/false
et$table$deg = abs(et$table$logFC) >= 2
if (should_filter) {
	et$table = et$table[et$table$deg,]
}
#write.table(et$table, file="edger.tsv", quote=FALSE, sep="\t")
write.table(data.frame("Gene"=rownames(et$table),et$table),"edger.tsv", row.names=FALSE, sep="\t", quote=FALSE)
