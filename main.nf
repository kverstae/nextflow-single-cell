nextflow.enable.dsl=2

include { cellranger_tenx } from './workflows/cellranger_10x'
include { seurat_single_sample } from './workflows/seurat_single_sample'

workflow {
    main:
        _out = cellranger_tenx \
        | map { it -> [it.toString().split('/')[-1], it + '/outs/filtered_feature_bc_matrix.h5']} \
        | seurat_single_sample
    emit:
        _out
}
