#! /usr/bin/python

import sys
import csv
import re

# Handle command line arguments
# =============================================================================
if len(sys.argv) < 3 or len(sys.argv) > 4:
    print("Usage: {} <fastq_path> <samplesheet> <prefixes_to_ignore>".format(sys.argv[0]))
    exit

fastq_dir = sys.argv[1]
samplesheet = sys.argv[2]
ignore = sys.argv[3].split(',') if len(sys.argv) == 4 else []

# Helper functions
# =============================================================================

def library_to_type(library, custom):
    if 'cDNA' in library:
        return "Gene Expression"
    if 'HTO' in library and custom:
        return "Custom"

    return "Antibody Capture"

def should_keep(library, ignore):
    library = library.split('_')[0]
    id = re.sub('[0-9]', '', library)
    
    return id not in ignore

# Extract libraries from samplesheet
# =============================================================================

libraries = set()

with open(samplesheet, 'r') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    next(reader, None)
    for line in reader:
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
            writer.writerow(["{}/outs/fastq_path".format(fastq_dir), library, "'{}'".format(library_to_type(library, custom))])
