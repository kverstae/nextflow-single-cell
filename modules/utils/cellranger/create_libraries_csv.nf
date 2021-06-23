nextflow.enable.dsl=2

process generate_libraries_csv {
    input:
        tuple path(samplesheet), path(fastq_dir), val(ids_to_ignore)

    output:
        file('*_libraries.csv')

    script:
        """
            $workflow.projectDir/../bin/utils/cellranger/generate_library_csv.py $fastq_dir $samplesheet $ids_to_ignore
        """
}