#!/usr/bin/env python
#./multifastaselect.py --in_fasta_filepath /mnt/scratch/multi.fa --out_filepath /mnt/scratch/ selected_ids seqA2,seqP
import argparse
from Bio import SeqIO
import argparse
import os
from pathlib import Path
import shlex
import subprocess
from multiprocessing import Pool

def extractfasta(in_path, out_path, selected_ids_string):
    fasta_sequences = SeqIO.parse(open(in_path),'fasta')
    output_file=out_path + "/selected.fa"
    out_file = open(output_file,'w')
    selected_ids = selected_ids_string.split(",")
    for fasta in fasta_sequences:
        name, sequence = fasta.description, str(fasta.seq)
        if(any(selected_id in name for selected_id in selected_ids)):
                SeqIO.write(fasta,out_file,"fasta")
    out_file.close()
                
    
def main():
    # store commandline args
    parser = argparse.ArgumentParser(description='MultiFastaSelect')
    parser.add_argument("--in_fasta_filepath", help='Input fasta path', required=True)
    parser.add_argument("--out_filepath", help='out path', required=True)
    parser.add_argument("--selected_ids", help='Selected fasta ids', required=True)
    parser.add_argument("--cpu_cores")
    args = parser.parse_args()
    extractfasta(args.in_fasta_filepath,args.out_filepath,args.selected_ids)

if __name__ == '__main__':
    main()
