nextflow.enable.dsl=2

process CONVERT_H5_TO_SEURAT_RDS {
    container params.seurat.container
    label 'mem'
    queue 'mem'

    input:
        file(in_h5)

    output:
        file('seuratObj.Rds')

    script:
        """
            ${workflow.projectDir}/bin/convert/seurat/h5_to_seurat_Rds.R \
            --input $in_h5 \
            --output seuratObj.Rds
        """
}