nextflow.enable.dsl=2

include { CONVERT_H5_TO_SEURAT_RDS } from '../modules/convert/seurat'

workflow seurat_single_sample {
    take:
        input_h5

    main:
        out = input_h5 \
        | CONVERT_H5_TO_SEURAT_RDS

    emit:
        out
}

workflow {
    main:
        seurat_single_sample(params.seurat.input_h5)
    emit:
        seurat_single_sample.out
}