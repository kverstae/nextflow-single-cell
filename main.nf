nextflow.enable.dsl=2

include { cellranger_tenx } from './workflows/cellranger_10x'
include { seurat_single_sample } from './workflows/seurat_single_sample'

workflow {
    main:
        cellranger_tenx()

    emit:
        cellranger_tenx.out
}