library(tidyverse)
library(ggupset)
n_int = as.integer(commandArgs(trailingOnly=TRUE))

trans <- read_delim("upset.tsv", delim = "\t", escape_double = FALSE, trim_ws = TRUE)
trans$f = str_split(trans$files, ',')

pl = trans %>% ggplot(aes(x=f)) + geom_bar() + scale_x_upset(n_intersections = n_int) + xlab("Shared output across results") + ylab("Number of shared results")
ggsave("upset.png")
pl = trans %>% ggplot(aes(x=f)) + geom_bar() + scale_x_upset(n_intersections = n_int, order_by="freq") + xlab("Shared output across results") + ylab("Number of shared results")
ggsave("upset-freq.png")
pl = trans %>% ggplot(aes(x=f)) + geom_bar() + scale_x_upset(n_intersections = n_int, order_by="degree") + xlab("Shared output across results") + ylab("Number of shared results")
ggsave("upset-degree.png")
