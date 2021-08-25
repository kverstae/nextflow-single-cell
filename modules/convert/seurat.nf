nextflow.enable.dsl=2

process CONVERT_H5_TO_SEURAT_RDS {
    container params.seurat.container
    label 'mem'
    queue 'mem'

    input:
        tuple val(id), file(h5_in)

    output:
        tuple val(id), file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/convert/seurat/h5_to_seurat_Rds.R \
            --input_filtered $h5_in \
            --output seuratObj.Rds
        """
}