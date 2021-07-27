nextflow.enable.dsl=2

include { CONVERT_H5_TO_SEURAT_RDS } from '../modules/convert/seurat';
include { SEURAT_LOGNORMALIZE} from '../modules/normalisation/seurat';
include { SEURAT_HVG } from '../modules/variable_features/seurat';
include { SEURAT_SCALE } from '../modules/scaling/seurat';
include { SEURAT_PCA; SEURAT_TSNE; SEURAT_UMAP } from '../modules/dimensionality_reduction/seurat';
include { SEURAT_NEIGHBORS; SEURAT_CLUSTER } from '../modules/clustering/seurat';

workflow seurat_single_sample {
    take:
        input_h5

    main:
        out = input_h5 \
        | CONVERT_H5_TO_SEURAT_RDS \
        | SEURAT_LOGNORMALIZE \
        | SEURAT_HVG \
        | SEURAT_SCALE \
        | SEURAT_PCA \
        | SEURAT_NEIGHBORS \
        | SEURAT_CLUSTER \
        | SEURAT_TSNE \
        | SEURAT_UMAP

    emit:
        out
}

workflow {
    main:
        data = Channel.fromPath(params.seurat.input_h5)
        seurat_single_sample(data)
    emit:
        seurat_single_sample.out
}