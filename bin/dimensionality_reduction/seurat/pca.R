#!/usr/bin/env Rscript

library("optparse")
library("Seurat")

### Argument parsing

option_list <- list(
    make_option(
        "--input",
        type = "character",
        dest = "input",
        help = "Input seurat object in Rds format",
        default = NULL
    ),
    make_option(
        "--output",
        type = "character",
        dest = "output",
        help = "Output seurat objec in Rds format"
    )
)

args <- parse_args(OptionParser(option_list = option_list))

# Run PCA

seuratObj <- readRDS(args$input)

seuratObj <- RunPCA(seuratObj, npcs = 150)

saveRDS(seuratObj, args$output)