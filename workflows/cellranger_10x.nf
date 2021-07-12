nextflow.enable.dsl=2

include { CELLRANGER_COUNT } from '../modules/mapping/cellranger';
include { CELLRANGER_LIBRARIES_CSV } from '../modules/utils/cellranger'
include { CELLRANGER_MKFASTQ } from '../modules/demultiplexing/cellranger';

workflow cellranger_tenx {
    main:
        out = Channel.fromPath(params.cellranger.input_csv) \
            | splitCsv(header: true, sep: ",") \
            | map { row -> [row.run_id, file(row.run_dir), file(row.samplesheet)] } \
            | CELLRANGER_MKFASTQ \
            | map { [file(it), params.cellranger.ids_to_ignore] } \
            | CELLRANGER_LIBRARIES_CSV \
            | flatMap { out -> out[0].collect{ in -> [ in.getFileName().toString().split('_')[0], in, out[1], file(params.cellranger.transcriptome), file(params.cellranger.feature_reference)] } } \
            | CELLRANGER_COUNT

    emit:
        out
}

workflow {
    main:
        cellranger_tenx()
    emit:
        cellranger_tenx.out
}
