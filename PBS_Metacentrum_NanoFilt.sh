#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=4:mem=32gb:scratch_local=250gb

trap 'clean_scratch' TERM EXIT
cd $SCRATCHDIR || exit 1

cp File_concatenated.fastq.gz $SCRATCHDIR/
cd $SCRATCHDIR

module load python36-modules-gcc

gunzip $SCRATCHDIR/File_concatenated.fastq.gz

NanoFilt -l 3000 -q 7 $SCRATCHDIR/File_concatenated.fastq | gzip > File_concatenated_filtered.fastq.gz
rm ${SCRATCHDIR}/*.fastq

cp -r ${SCRATCHDIR}/* /PATH/to/my/output/folder/ || CLEAN_SCRATCH=true
