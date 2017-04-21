#!/bin/bash

#PBS -W group_list=bhurwitz
#PBS -q standard
#PBS -l select=9:ncpus=28:mem=46gb
#PBS -l pvmem=200gb
#PBS -l walltime=48:00:00
#PBS -l cput=48:00:00
#PBS -M jamesthornton@email.arizona.edu
#PBS -m bea

UNMAPPED_DIR="/rsgrps/bhurwitz/jetjr/neutropenicfever/BMT/new/unmapped"
CLARK_DIR="/rsgrps/bhurwitz/hurwitzlab/bin/CLARK"
CLARK_DB="$CLARK_DIR/Database"

export KMER_SIZE="31"
export MODE="1"
export NUM_THREAD="8"
export CLARK_OUT_DIR="/rsgrps/bhurwitz/jetjr/neutropenicfever/BMT/unmapped"

cd "$UNMAPPED_DIR"
export FASTA_LIST="$UNMAPPED_DIR/fasta-list"

ls *.unmapped > $FASTA_LIST
echo "FASTA files to be processed:" $(cat $FASTA_LIST)

while read FASTA; do

FILE_NAME=`basename $FASTA`
BT2_OUT="$UNMAPPED_DIR/$FASTA"

cd "$CLARK_DIR"
./classify_metagenome.sh -k $KMER_SIZE -O $BT2_OUT -R $CLARK_OUT_DIR/$FILE_NAME.results -m $MODE -n $NUM_THREAD

./estimate_abundance.sh -F $CLARK_OUT_DIR/$FILE_NAME.results.csv -D $CLARK_DB >> $CLARK_OUT_DIR/$FILE_NAME.abundance.csv  

done < $FASTA_LIST
