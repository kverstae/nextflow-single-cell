#!/usr/bin/env Rscript

library("optparse")
library("Seurat")

option_list <- list(
    make_option(
        "--input",
        type = "character",
        dest = "input",
        help = "Input h5 file"
    ),
    make_option(
        "--output",
        type = "character",
        dest = "output",
        help = "Output Rds file"
    )
)

args <- parse_args(OptionParser(option_list = option_list))

data <- Read10X_h5(args$input)

seuratObj <- CreateSeuratObject(data)

saveRDS(seuratObj, args$output)
