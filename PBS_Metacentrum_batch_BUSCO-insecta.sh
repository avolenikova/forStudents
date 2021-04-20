#!/bin/bash
#usage: $ bash ThisScript.sh /PATH/to/input/dir/ /PATH/to/output/dir/
#1) PREPARE ENVIRONMENT
inputDir=$1
timeStamp=$(date +"%Y%m%d.%H%M")
outDir=${2}BUSCO_ins_${timeStamp}
mkdir $outDir
cd $outDir
#2) CHOOSE DATA AND PRINT PBS SCRIPT
for file in "${1}"*.fasta.gz
do
	fileName="$(basename "$file" .fasta.gz)"
	baseName="$(basename "$file")"
	scriptName=${outDir}/BUSCO_ins_"${fileName}".pbs
	(
	cat << endOfPBSscript
#!/bin/bash
#PBS -N BUSCO-ins
#PBS -l select=1:ncpus=2:mem=32gb:scratch_local=250gb
#PBS -l walltime=71:00:00
#PBS -o ${outDir}/${fileName}_BUSCO-ins.stdout
#PBS -e ${outDir}/${fileName}_BUSCO-ins.stderr

trap 'clean_scratch' TERM EXIT

scp ${file} \${SCRATCHDIR} || exit 1
cp -r /software/busco/3.0.2/src/db/insecta_odb9/ \${SCRATCHDIR} || exit 1
cp -r /software/augustus/3.3.1/src/config \${SCRATCHDIR} || exit 1

cd \${SCRATCHDIR} || exit 2

chmod -R 777 \${SCRATCHDIR}/config

gunzip ${baseName}

module add busco-3.0.2
export AUGUSTUS_CONFIG_PATH=\${SCRATCHDIR}/config

run_BUSCO.py -c 1 -i \${SCRATCHDIR}/${fileName}.fasta -o ${fileName}_ins_busco.out -l \${SCRATCHDIR}/insecta_odb9/ -m geno

rm \${SCRATCHDIR}/${fileName}.fasta

scp -r \${SCRATCHDIR}/* ${outDir} || export CLEAN_SCRATCH=true

endOfPBSscript

	) > ${scriptName}
	chmod +x ${scriptName}
	qsub ${scriptName}
done
