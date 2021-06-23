nextflow.enable.dsl=2

def librariesToSampleName(libraries) {
    println(libraries)
}

process count {
    input:
        tuple val(id), file(libraries), path(transcriptome), path(feature_reference)

    output:
        path(id)

    script:
        """
            cellranger count --id=$id \
                --libraries=$libraries \
                --transcriptome=$transcriptome \
                --feature_reference=$feature_reference
        """
}