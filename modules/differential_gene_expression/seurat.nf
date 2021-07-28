nextflow.enable.dsl=2

process SEURAT_DEG {
    container params.seurat.container
    publishDir params.out
    label 'mem'
    queue 'mem'

    input:
        file(seurat_in)

    output:
        file('markers.xlsx')

    script:
        """
            ${workflow.projectDir}/bin/deg/seurat/deg.R \
            --input $seurat_in \
            --output markers.xlsx
        """
}