library(tidyverse)
library(ggupset)

args = commandArgs(trailingOnly=TRUE)
n_int = as.integer(args[1])
files = args[-1]

# gene, (list of matching conditions)
data <- list()
for (idx in 1:length(files)) {
  k <- files[idx]
  data[k] <- read_tsv(k, col_names=c("genes"))
}

all_genes <- c()
for(gene_list in data){
  for(gene in gene_list){
    all_genes <- append(all_genes, gene)
  }
}
all_genes <- unique(sort(all_genes))

trans <- tibble(gene=character(), files=character())
for (gene_idx in 1:length(all_genes)) {
  gene = all_genes[gene_idx]
  files <- names(data)[grep(gene, data)]
  files <- paste(files, sep=",", collapse=",")
  trans = trans %>% add_row(gene=gene, files=files)
}

# write_tsv(df, "upset.tsv")
#trans <- read_delim("upset.tsv", delim = "\t", escape_double = FALSE, trim_ws = TRUE)
trans$f = str_split(trans$files, ',')

pl = trans %>% ggplot(aes(x=f)) + geom_bar() + scale_x_upset(n_intersections = n_int) + xlab("Shared output across results") + ylab("Number of shared results")
ggsave("upset.png")
pl = trans %>% ggplot(aes(x=f)) + geom_bar() + scale_x_upset(n_intersections = n_int, order_by="freq") + xlab("Shared output across results") + ylab("Number of shared results")
ggsave("upset-freq.png")
pl = trans %>% ggplot(aes(x=f)) + geom_bar() + scale_x_upset(n_intersections = n_int, order_by="degree") + xlab("Shared output across results") + ylab("Number of shared results")
ggsave("upset-degree.png")
