#!/usr/bin/env python

import sys
import csv
import re

# Handle command line arguments
# =============================================================================
if len(sys.argv) < 2 or len(sys.argv) > 3:
    print("Usage: {} <fastq_path> <prefixes_to_ignore>".format(sys.argv[0]))
    exit

fastq_dir = sys.argv[1]
ignore = sys.argv[2].split(',') if len(sys.argv) == 3 else []

# Helper functions
# =============================================================================

def library_to_type(library, custom):
    if 'cdna' in library.lower():
        return "Gene Expression"
    if 'hto' in library.lower() and custom:
        return "Custom"

    return "Antibody Capture"

def should_keep(library, ignore):
    library = library.split('_')[0]
    id = re.sub('[0-9]', '', library)
    
    return id not in ignore

# Extract libraries from samplesheet
# =============================================================================

samplesheet = "{}/outs/input_samplesheet.csv".format(fastq_dir)
libraries = set()

with open(samplesheet, 'r') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    next(reader, None)
    for line in reader:
        if len(line) == 0:
            continue
        libraries.add(line[1])

samples = filter(lambda s: should_keep(s, ignore), set(map(lambda l: l.split('_')[0], libraries)))

# Create libraries CSV for each sample in the samplesheet
# =============================================================================

for sample in samples:
    custom = False
    sample_libraries = list(filter(lambda l: sample in l, libraries))

    if "{}_ADT".format(sample) in sample_libraries and "{}_HTO".format(sample) in sample_libraries:
        custom = True
    
    with open("{}_libraries.csv".format(sample), 'w') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(['fastqs', 'sample', 'library_type'])
        
        for library in sample_libraries:
            writer.writerow(["{}/outs/fastq_path".format(fastq_dir), library, "{}".format(library_to_type(library, custom))])
