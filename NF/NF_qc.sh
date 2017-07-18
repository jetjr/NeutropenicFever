#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=1:ncpus=4:mem=15gb
#PBS -l pvmem=14gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M jamesthornton@email.arizona.edu
#PBS -m bea

FASTQ_DIR="/rsgrps/bhurwitz/jetjr/neutropenicfever/final"

cd "$FASTQ_DIR"

module load fastx/0.0.14

cat IonXpress_001_NF002.fq | fastx_trimmer -f 10 -l 175 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > NF002.fasta

cat IonXpress_002_NF003.fq | fastx_trimmer -f 10 -l 175 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > NF003.fasta

cat IonXpress_017_NF004.fq | fastx_trimmer -f 10 -l 170 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > NF004.fasta

cat IonXpress_018_NF005.fq | fastx_trimmer -f 10 -l 170 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > NF005.fasta

cat IonXpress_019_NF006.fq | fastx_trimmer -f 10 -l 165 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > NF006.fasta

cat IonXpress_058_NF001.fq | fastx_trimmer -f 10 -l 300 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > NF001.fasta     

