nextflow.enable.dsl=2

process SEURAT_PCA {
    container params.seurat.container
    label 'mem'
    queue 'mem'

    input:
        file(seurat_in)

    output:
        file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/dimensionality_reduction/seurat/pca.R \
            --input $seurat_in \
            --output seuratObj.Rds
        """
}

process SEURAT_TSNE {
    container params.seurat.container
    label 'mem'
    queue 'mem'

    input:
        file(seurat_in)

    output:
        file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/dimensionality_reduction/seurat/tsne.R \
            --input $seurat_in \
            --output seuratObj.Rds
        """
}

process SEURAT_UMAP {
    container params.seurat.container
    label 'mem'
    queue 'mem'

    input:
        file(seurat_in)

    output:
        file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/dimensionality_reduction/seurat/umap.R \
            --input $seurat_in \
            --output seuratObj.Rds
        """
}