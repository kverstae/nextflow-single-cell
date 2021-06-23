nextflow.enable.dsl=2

process mkfastq {
    input:
        tuple val(id), path(run), file(csv)

    output:
        path(id)

    script:
        """
            cellranger mkfastq --id=$id \
                --run=$run \
                --csv=$csv
        """
}