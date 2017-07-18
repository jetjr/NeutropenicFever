#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l jobtype=cluster_only
#PBS -l select=1:ncpus=4:mem=15gb
#PBS -l pvmem=14gb
#PBS -l place=pack:shared
#PBS -l walltime=24:00:00
#PBS -l cput=24:00:00
#PBS -M jamesthornton@email.arizona.edu
#PBS -m bea

FASTQ_DIR="/rsgrps/bhurwitz/jetjr/bugmix/fastq"

cd "$FASTQ_DIR"

module load fastx/0.0.14

cat IonXpress_001_LiveBug.E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 250 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_001_LiveBug.E.coli.S.saprophyticus.fasta

cat IonXpress_023_Ecoli.fastq | fastx_trimmer -f 10 -l 260 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_023_Ecoli.fasta

cat IonXpress_024_Sflexneri.fastq | fastx_trimmer -f 10 -l 250 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_024_Sflexneri.fasta

cat IonXpress_025_MSSA.fastq | fastx_trimmer -f 10 -l 220 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_025_MSSA.fasta

cat IonXpress_026_MRSA.fastq | fastx_trimmer -f 10 -l 220 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_026_MRSA.fasta

cat IonXpress_027_SSaprophyticus.fastq | fastx_trimmer -f 10 -l 250 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_027_SSaprophyticus.fasta     

cat IonXpress_028_Spyogenes.fastq | fastx_trimmer -f 10 -l 260 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_028_Spyogenes.fasta     

cat IonXpress_062_MRSA.MSSA.fastq | fastx_trimmer -f 10 -l 200 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_062_MRSA.MSSA.fasta     

cat IonXpress_063_MRSA.MSSA.fastq | fastx_trimmer -f 10 -l 200 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_063_MRSA.MSSA.fasta     

cat IonXpress_064_MRSA.MSSA.fastq | fastx_trimmer -f 10 -l 200 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_064_MRSA.MSSA.fasta     

cat IonXpress_065_MRSA.MSSA.fastq | fastx_trimmer -f 10 -l 200 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_065_MRSA.MSSA.fasta     

cat IonXpress_066_MRSA.MSSA.fastq | fastx_trimmer -f 10 -l 200 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_066_MRSA.MSSA.fasta     

cat IonXpress_067_MRSA.MSSA.fastq | fastx_trimmer -f 10 -l 220 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_067_MRSA.MSSA.fasta     

cat IonXpress_068_MRSA.MSSA.fastq | fastx_trimmer -f 10 -l 200 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_068_MRSA.MSSA.fasta     

cat IonXpress_069_E.coli.S.sonnei.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_069_E.coli.S.sonnei.fasta     

cat IonXpress_070_E.coli.S.sonnei.fastq | fastx_trimmer -f 10 -l 170 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_070_E.coli.S.sonnei.fasta

cat IonXpress_071_E.coli.S.sonnei.fastq | fastx_trimmer -f 10 -l 170 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_071_E.coli.S.sonnei.fasta

cat IonXpress_072_E.coli.S.sonnei.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_072_E.coli.S.sonnei.fasta

cat IonXpress_073_E.coli.S.sonnei.fastq | fastx_trimmer -f 10 -l 170 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_073_E.coli.S.sonnei.fasta

cat IonXpress_075_E.coli.S.sonnei.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_075_E.coli.S.sonnei.fasta

cat IonXpress_076_E.coli.S.sonnei.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_076_E.coli.S.sonnei.fasta

cat IonXpress_077_S.saprophyticus.S.pyogenes.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_077_S.saprophyticus.S.pyogenes.fasta

cat IonXpress_078_S.saprophyticus.S.pyogenes.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_078_S.saprophyticus.S.pyogenes.fasta

cat IonXpress_079_S.saprophyticus.S.pyogenes.fastq | fastx_trimmer -f 10 -l 200 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_079_S.saprophyticus.S.pyogenes.fasta

cat IonXpress_080_S.saprophyticus.S.pyogenes.fastq | fastx_trimmer -f 10 -l 200 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_080_S.saprophyticus.S.pyogenes.fasta

cat IonXpress_081_S.saprophyticus.S.pyogenes.fastq | fastx_trimmer -f 10 -l 200 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_081_S.saprophyticus.S.pyogenes.fasta

cat IonXpress_082_S.saprophyticus.S.pyogenes.fastq | fastx_trimmer -f 10 -l 200 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_082_S.saprophyticus.S.pyogenes.fasta

cat IonXpress_083_S.saprophyticus.S.pyogenes.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_083_S.saprophyticus.S.pyogenes.fasta

cat IonXpress_084_E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_084_E.coli.S.saprophyticus.fasta

cat IonXpress_085_E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_085_E.coli.S.saprophyticus.fasta

cat IonXpress_086_E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_086_E.coli.S.saprophyticus.fasta

cat IonXpress_087_E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 180 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_087_E.coli.S.saprophyticus.fasta

cat IonXpress_088_E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_088_E.coli.S.saprophyticus.fasta

cat IonXpress_089_E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_089_E.coli.S.saprophyticus.fasta

cat IonXpress_090_E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_090_E.coli.S.saprophyticus.fasta

cat IonXpress_091_LiveBug.E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 170 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_091_LiveBug.E.coli.S.saprophyticus.fasta

cat IonXpress_092_LiveBug.E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 170 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_092_LiveBug.E.coli.S.saprophyticus.fasta

cat IonXpress_093_LiveBug.E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 170 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_093_LiveBug.E.coli.S.saprophyticus.fasta

cat IonXpress_094_LiveBug.E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 170 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_094_LiveBug.E.coli.S.saprophyticus.fasta

cat IonXpress_095_LiveBug.E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_095_LiveBug.E.coli.S.saprophyticus.fasta

cat IonXpress_096_LiveBug.E.coli.S.saprophyticus.fastq | fastx_trimmer -f 10 -l 190 | fastq_quality_filter -q 17 -p 80 | fastx_clipper -l 50 | fastx_collapser > IonXpress_096_LiveBug.E.coli.S.saprophyticus.fasta
