nextflow.enable.dsl=2

process SEURAT_LOGNORMALIZE {
    container params.seurat.container
    label 'mem'
    queue 'mem'

    input:
        file(seurat_in)

    output:
        file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/normalize/seurat/lognormalize.R \
            --input $seurat_in \
            --output seuratObj.Rds
        """
}