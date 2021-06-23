nextflow.enable.dsl=2

include { count } from '../modules/mapping/cellranger';
include { generate_libraries_csv } from '../modules/utils/cellranger/create_libraries_csv'
include { mkfastq } from '../modules/demultiplexing/cellranger';

workflow tenX {
    main:
        out = Channel.fromPath(params.input_csv) \
            | splitCsv(header: true, sep: ",") \
            | mkfastq \
            | map { fastq_dir -> [file("$fastq_dir/outs/input_samplesheet.csv"), fastq_dir, params.ids_to_ignore]} \
            | generate_libraries_csv
            | flatten
            | map { libraries -> [libraries.getFileName().toString().split('_')[0], file(libraries), params.transcriptome, params.feature_reference]}
            | count

    emit:
        out
}