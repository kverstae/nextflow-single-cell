nextflow.enable.dsl=2

process CELLRANGER_COUNT {
    container params.cellranger.container
    publishDir "${params.out}/COUNTS", mode: 'copy'
    label 'cpu_mem'
    queue 'cpumem'
    pod nodeSelector: 'agentpool=cpumem'

    input:
        tuple val(id), file(libraries), path(fastq_path), path(transcriptome), path(feature_reference)

    output:
        path(id)

    script:
        """
            cellranger count --id=$id \
                --libraries=$libraries \
                --transcriptome=$transcriptome \
                --feature-ref=$feature_reference
        """
}
