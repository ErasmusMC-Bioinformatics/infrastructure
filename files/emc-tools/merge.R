files <- commandArgs(trailingOnly = TRUE)

data = lapply(files, function(x) read.csv(x, sep="\t"))
merged = Reduce(function(dtf1, dtf2) merge(dtf1, dtf2, by = "Gene", all.x = TRUE), data)
c = colnames(merged)

colnames(merged) = c("Gene", files)
write.table(merged, "merged.tsv", row.names=FALSE, sep="\t", quote=FALSE)
