#!/usr/bin/env python3
# calc GC of seqs in FASTA
# cjfiscus
# 8/21/19
# 
# usage
# calc_gc_seqs.py seqs.fa > gc.txt

import sys 
from Bio import SeqIO
from Bio.SeqUtils import GC

for seq_record in SeqIO.parse(sys.argv[1],"fasta"):
    gc_content = GC(seq_record.seq)	
    print(seq_record.id +"\t" + "{:.2f}".format(gc_content))
