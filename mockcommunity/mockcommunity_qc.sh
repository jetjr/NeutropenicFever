#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=4:mem=15gb
#PBS -l pvmem=14gb
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M jamesthornton@email.arizona.edu
#PBS -m bea

FASTA_DIR="/rsgrps/bhurwitz/jetjr/mockcommunity"

cd $FASTA_DIR

module load fastx/0.0.14

for FILE in $(cat list); do

  FILE_NAME=$(basename $FILE | cut -d '.' -f 1)
  cat $FILE | fastx_trimmer -f 10 -l 170 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > $FILE_NAME.fasta

done
