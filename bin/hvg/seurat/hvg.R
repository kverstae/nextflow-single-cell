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

# Determine variable features in the data 

seuratObj <- readRDS(args$input)

seuratObj <- FindVariableFeatures(seuratObj)

saveRDS(seuratObj, args$output)