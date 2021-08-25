#!/usr/bin/env Rscript

library("optparse")
library("Seurat")
library("Matrix")

### Argument parsing

option_list <- list(
    make_option(
        "--input_filtered",
        type = "character",
        dest = "input_filtered",
        help = "Filtered input h5 file",
        default = NULL
    ),
    make_option(
        "--input_raw",
        type = "character",
        dest = "input_filtered",
        help = "Raw input h5 file",
        default = NULL
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
        help = "Assays to create in the Seurat object. Only supported assays are RNA, ADT (CITESeq) and HTO (hashing). Values need to be commma separated",
        default = ""
    ),
    make_option(
        "--min_cells",
        type = "integer",
        default = 3,
        dest = "min_cells",
        help = "Minimal number of cells for a feature"
    ),
    make_option(
        "--min_features",
        type = "integer",
        default = 200,
        dest = "min_features",
        help = "Minimal number of features for a cell"
    )
)

args <- parse_args(OptionParser(option_list = option_list))
args$assays <- unlist(strsplit(args$assays, ","))
if (length(args$assays) == 0) {
    args$assays <- NULL
}

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

createMultimodalSeurat <- function(data, assaysToKeep = NULL, min.cells = 3, min.features = 200) {
    assays <- list()

    if (!is.list(data) && (is.null(assaysToKeep) || "RNA" %in% assaysToKeep)) {
        # Data is not a list, so it has to be a matrix with RNA data
        assays <- addAssayToList(data, assays, "RNA")
    } else {
        for (modality in names(data)) {
            assayName <- modalityToAssay(modality, data[[modality]])
            if (is.null(assaysToKeep) || assayName %in% assaysToKeep) {
                assays <- addAssayToList(data[[modality]], assays, assayName)
            }
        }
    }

    if (!"RNA" %in% names(assays)) {
        stop("Missing RNA assay, cannot create Seurat object")
    }

    message("Adding RNA assay to object")
    seuratObj <- CreateSeuratObject(counts = assays[["RNA"]], assay = "RNA", min.cells = min.cells, min.features = min.features)
    assays[["RNA"]] <- NULL
    cells <- colnames(seuratObj)

    for (assay in names(assays)) {
        message(paste0("Adding ", assay, " assay to object"))
        seuratObj[[assay]] <- CreateAssayObject(assays[[assay]][, cells])
    }

    return(seuratObj)
}

addMatrixSourceMeta <- function(object, filtered_matrix = NULL, raw_matrix = NULL) {

    if (!is.null(filtered_matrix) && !is.null(raw_matrix)) {
        object@meta.data$source_matrix <- "raw"
        object@meta.data[colnames(filtered_matrix), "source_matrix"] <- "filtered"
    } else if (is.null(filtered_matrix)) {
        object@meta.data$source_matrix <- "raw"
    } else if (is.null(raw_matrix)) {
        object@meta.data$source_matrix <- "filtered"
    } else {
        stop("No matrices provided")
    }

    return(object)
}

### Create Seurat object

if (is.null(args$input_filtered) && is.null(args$input_raw)) {
    stop("Missing input files!", call. = F)
}

data.filtered <- NULL
data.raw <- NULL

if (!is.null(args$input_filtered)) {
    data.filtered <- Read10X_h5(args$input_filtered)
}

if (!is.null(args$input_raw)) {
    data <- Read10X_h5(args$input_raw)
} else {
    data <- data.filtered
}

seuratObj <- createMultimodalSeurat(data, args$assays, args$min_cells, args$min_features)
seuratObj <- addMatrixSourceMeta(seuratObj, if (is.list(data.filtered)) data.filtered[["Gene Expression"]] else data.filtered, if (is.list(data)) data[["Gene Expression"]] else data)

saveRDS(seuratObj, args$output)
