#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=8:mem=32gb:scratch_local=500gb

trap 'clean_scratch' TERM EXIT
cd $SCRATCHDIR || exit 1

cp File_concatenated.fastq.gz $SCRATCHDIR/
cd $SCRATCHDIR

gunzip $SCRATCHDIR/File_concatenated.fastq.gz

module load python36-modules-gcc

NanoPlot -t 7 --outdir $SCRATCHDIR/ --prefix Species_ONT_raw_concatenated --N50 --format png --fastq $SCRATCHDIR/File_concatenated.fastq

rm ${SCRATCHDIR}/Pcal_F33n_ONT_raw_concat.fastq

cp -r ${SCRATCHDIR}/* /PATH/to/my/output/folder/ || CLEAN_SCRATCH=true
