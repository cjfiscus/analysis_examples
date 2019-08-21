#!/bin/bash 

module load ncbi-blast/2.8.1+

GENOME=path/to/genome.fa
QUERY=path/to/seqs.fa
RESULTS=path/to/results.txt

# blast search against genome
## mk blast db
makeblastdb -in "$GENOME" -parse_seqids -dbtype nucl -out custom_db

## blastn search (default is megablast)
blastn -task blastn -outfmt 6 -db custom_db -query "$QUERY" -out "$RESULTS"
