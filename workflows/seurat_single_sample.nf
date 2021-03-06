nextflow.enable.dsl=2

include { CONVERT_H5_TO_SEURAT_RDS } from '../modules/convert/seurat';
include { SEURAT_LOGNORMALIZE} from '../modules/normalisation/seurat';
include { SEURAT_HVG } from '../modules/variable_features/seurat';
include { SEURAT_SCALE } from '../modules/scaling/seurat';
include { SEURAT_PCA; SEURAT_TSNE; SEURAT_UMAP } from '../modules/dimensionality_reduction/seurat';
include { SEURAT_NEIGHBORS; SEURAT_CLUSTER } from '../modules/clustering/seurat';
include { SEURAT_DEG } from '../modules/differential_gene_expression/seurat';

workflow seurat_single_sample {
    take:
        input // tuple of format [id, h5]

    main:
        out = input \
        | CONVERT_H5_TO_SEURAT_RDS \
        | SEURAT_LOGNORMALIZE \
        | SEURAT_HVG \
        | SEURAT_SCALE \
        | SEURAT_PCA \
        | SEURAT_NEIGHBORS \
        | SEURAT_CLUSTER \
        | SEURAT_TSNE \
        | SEURAT_UMAP

        SEURAT_DEG(out)

    emit:
        out // tuple of format [id, seuratObj.Rds]
}

workflow {
    main:
        data = Channel.fromPath(params.seurat.input_h5) \
        | map { p -> [params.seurat.id, p] }

        seurat_single_sample(data)
    emit:
        seurat_single_sample.out
}