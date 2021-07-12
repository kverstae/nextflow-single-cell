nextflow.enable.dsl=2

process CELLRANGER_MKFASTQ {
    container params.cellranger.container
    publishDir "${params.out}/FASTQ", mode: 'copy'
    label 'cpu_mem'

    input:
        tuple val(id), path(run), file(csv)

    output:
        path(id)

    script:
        """
            cellranger mkfastq --id=$id \
                --run=$run \
                --csv=$csv \
                --localcores=${task.cpus} \
                --localmem=${task.memory.toGiga()}
        """
}