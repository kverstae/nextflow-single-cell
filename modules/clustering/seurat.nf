nextflow.enable.dsl=2

process SEURAT_NEIGHBORS {
    container params.seurat.container
    label 'mem'
    queue 'mem'

    input:
        file(seurat_in)

    output:
        file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/clustering/seurat/neighbors.R \
            --input $seurat_in \
            --output seuratObj.Rds
        """
}

process SEURAT_CLUSTER {
    container params.seurat.container
    label 'mem'
    queue 'mem'

    input:
        file(seurat_in)

    output:
        file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/clustering/seurat/cluster.R \
            --input $seurat_in \
            --output seuratObj.Rds
        """
}