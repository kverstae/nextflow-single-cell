#!/usr/bin/env Rscript

library("optparse")
library("Seurat")
library("openxlsx")

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
        help = "Output xlsx with marker genes"
    )
)

args <- parse_args(OptionParser(option_list = option_list))

# Run tSNE

seuratObj <- readRDS(args$input)

markers <- FindAllMarkers(seuratObj)

markersList <- list()
for (cluster in unique(markers$cluster)) {
    markersList[[cluster]] <- markers[markers$cluster == cluster]
}

write.xlsx(markersList, file = opt$output)