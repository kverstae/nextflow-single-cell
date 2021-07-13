nextflow.enable.dsl=2

process CELLRANGER_LIBRARIES_CSV {
    container "python:3.8-slim"
    publishDir "${params.out}/RUNFILES", mode: 'copy', pattern: '*_libraries.csv'
    queue 'small'

    input:
        tuple path(fastq_dir), val(ids_to_ignore)

    output:
        tuple file('*_libraries.csv'), path(fastq_dir)

    script:
        """
            ${workflow.projectDir}/bin/utils/cellranger/generate_library_csv.py $fastq_dir $ids_to_ignore
        """
}