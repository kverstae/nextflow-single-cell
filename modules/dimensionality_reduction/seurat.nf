nextflow.enable.dsl=2

process SEURAT_PCA {
    container params.seurat.container
    label 'mem'
    queue 'mem'
    pod nodeSelector: 'agentpool=cpumem'

    input:
        tuple val(id), file(seurat_in)

    output:
        tuple val(id), file('seuratObj.Rds')

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
    pod nodeSelector: 'agentpool=cpumem'

    input:
        tuple val(id), file(seurat_in)

    output:
        tuple val(id), file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/dimensionality_reduction/seurat/tsne.R \
            --input $seurat_in \
            --output seuratObj.Rds
        """
}

process SEURAT_UMAP {
    container params.seurat.container
    publishDir "${params.out}/PROCESSED/${id}", mode: 'copy'
    label 'mem'
    queue 'mem'
    pod nodeSelector: 'agentpool=cpumem'

    input:
        tuple val(id), file(seurat_in)

    output:
        tuple val(id), file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/dimensionality_reduction/seurat/umap.R \
            --input $seurat_in \
            --output seuratObj.Rds
        """
}
