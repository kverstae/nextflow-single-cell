nextflow.enable.dsl=2

process SEURAT_DEG {
    container params.seurat.container
    publishDir "${params.out}/PROCESSED/${id}", mode: 'copy'
    label 'mem'
    queue 'mem'
    pod nodeSelector: 'agentpool=cpumem'    

    input:
        tuple val(id), file(seurat_in)

    output:
        tuple val(id), file('markers.Rds')

    script:
        """
            ${workflow.projectDir}/bin/deg/seurat/deg.R \
            --input $seurat_in \
            --output markers.Rds
        """
}
