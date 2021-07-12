## Workflow cellranger 10x

Process raw sequencing data (bcl format) to a count matrix, using the cellranger pipeline.

Input CSV is of the following format:

```
run_id, run_dir, samplesheet
Exp1234, /path/to/bcl/files/Exp1234, Exp1234_samplesheet.csv
Exp4321, /path/to/bcl/files/Exp4321, Exp4321_samplesheet.csv
```