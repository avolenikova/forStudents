#!/bin/bash
#PBS -N Trimmomatic
#PBS -l select=1:ncpus=16:mem=32gb:scratch_local=100gb
#PBS -l walltime=48:00:00
#PBS -o /storage/brno11-elixir/home/volen_a/klup/03_trimmomatic/Trimmomatic_20210426.1113/Klup_41_Trimmomatic.stdout
#PBS -e /storage/brno11-elixir/home/volen_a/klup/03_trimmomatic/Trimmomatic_20210426.1113/Klup_41_Trimmomatic.stderr

trap 'clean_scratch' TERM EXIT

cd ${SCRATCHDIR}

scp /storage/brno11-elixir/home/volen_a/klup/01_fastq/Klup_41_1.fastq.gz ${SCRATCHDIR}
scp /storage/brno11-elixir/home/volen_a/klup/01_fastq/Klup_41_2.fastq.gz ${SCRATCHDIR}
scp /storage/brno11-elixir/home/volen_a/klup/03_trimmomatic/*.fa ${SCRATCHDIR} || exit 1 

module add trimmomatic-0.39

java -jar /software/trimmomatic/0.39/trimmomatic-0.39/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 15 -phred33 -trimlog Klup_41_trimlog.txt -basein Klup_41_1.fastq.gz -baseout Klup_41_trimmed.fastq.gz ILLUMINACLIP:Truseq_PE_frankenstein.fa:2:30:10:1:true SLIDINGWINDOW:5:20 CROP:135 HEADCROP:30 MINLEN:100

rm ${SCRATCHDIR}/Klup_41_1.fastq.gz
rm ${SCRATCHDIR}/Klup_41_2.fastq.gz

scp -r ${SCRATCHDIR}/* /storage/brno11-elixir/home/volen_a/klup/03_trimmomatic/Trimmomatic_20210426.1113 || export CLEAN_SCRATCH=true

