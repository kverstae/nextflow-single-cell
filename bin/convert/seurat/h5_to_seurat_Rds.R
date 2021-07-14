#!/usr/bin/env Rscript

library("optparse")
library("Seurat")
library("Matrix")

### Argument parsing

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
    ),
    make_option(
        "--assays",
        type = "character",
        dest = "assays",
        help = "Assays to create in the Seurat object. Only supported assays are RNA, ADT (CITESeq) and HTO (hashing). Values need to be commma separated"
    )
)

args <- parse_args(OptionParser(option_list = option_list))
args$assays <- unlist(strsplit(args$assays, ","))

### Functions

modalityToAssay <- function(modality, data){
    if (modality == "Gene Expression") {
        assay.name <- "RNA"
    } else if (modality == "Custom") {
        assay.name <- "HTO"
    } else if (modality == "Antibody Capture") {
        if (length(grep("^Hashtag", rownames(data))) == nrow(data)) {
            assay.name <- "HTO"
        } else {
            assay.name <- "ADT"
        }
    } else {
        stop("Unsupported modality: ", modality)
    }

    return(assay.name)
}

addAssayToList <- function(data, list, assay) {
    if (assay %in% names(list)) {
        warning(paste0("Assay ", assay, " alread in list, so skipping..."))
    }
    list[[assay]] <- data
    return(list)
}

createMultimodalSeurat <- function(data, assaysToKeep = NULL) {
    assays <- list()

    if (!is.list(data) && (is.null(assaysToKeep) || 'RNA' %in% assaysToKeep)) {
        # Data is not a list, so it has to be a matrix with RNA data
        assays <- addAssayToList(data, assays, 'RNA')
    } else {
        for (modality in names(data)) {
            assayName <- modalityToAssay(modality, data[[modality]])
            if (is.null(assaysToKeep) || assayName %in% assaysToKeep) {
                assays <- addAssayToList(data[[modality]], assays, assayName)
            }
        }
    }

    if (!'RNA' %in% names(assays)) {
        stop("Missing RNA assay, cannot create Seurat object")
    }

    message("Adding RNA assay to object")
    seuratObj <- CreateSeuratObject(counts = assays[['RNA']])
    assays[['RNA']] <- NULL

    for (assay in names(assays)) {
        message(paste0("Adding ", assay, " assay to object"))
        seuratObj[[assay]] <- CreateAssayObject(assays[[assay]], assay = assay)
    }

    return(seuratObj)
}

### Create Seurat object

data <- Read10X_h5(args$input)

seuratObj <- createMultimodalSeurat(data, args$assays)

saveRDS(seuratObj, args$output)
