nextflow.enable.dsl=2

process SEURAT_SCALE {
    container params.seurat.container
    label 'mem'
    queue 'mem'

    input:
        file(seurat_in)

    output:
        file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/scale/seurat/scale.R \
            --input $seurat_in \
            --output seuratObj.Rds
        """
}