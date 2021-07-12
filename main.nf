nextflow.enable.dsl=2

include { cellranger_tenx } from './workflows/cellranger_10x'
include { seurat_single_sample } from './workflows/seurat_single_sample'

workflow {
    main:
        cellranger_tenx \
        | map { it.toString() + '/outs/' + params.input_type + '_feature_bc_matrix.h5' } \
        | seurat_single_sample

    emit:
        seurat_single_sample.out
}