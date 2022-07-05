#!/bin/sh
#FILENAME: 
#SBATCH -A bharpur
#SBATCH -n 1
#SBATCH --ntasks=1
#SBATCH -t 0-00:20:00

#var 1: fastq
#var 2: run accesssion

#load modules
module load bioinfo
module load samtools
module load picard-tools/2.9.0

wget $1 -O /depot/bharpur/data/projects/keishi/fastq_files/"$2".fastq.gz

/depot/bharpur/apps/NextGenMap-0.5.2/bin/ngm-0.5.2/ngm -r /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna -q /depot/bharpur/data/projects/keishi/fastq_files/"$2".fastq.gz | samtools sort > /depot/bharpur/data/projects/keishi/bam_files/"$2".bam

rm /depot/bharpur/data/projects/keishi/fastq_files/"$2".fastq.gz

java -jar $CLASSPATH AddOrReplaceReadGroups \
	I=/depot/bharpur/data/projects/keishi/bam_files/"$2".bam \
	O=/depot/bharpur/data/projects/keishi/updated_bam_files/"$2"_updated.bam \
	RGID=1 \
	RGLB=lib1 \
	RGPL=illumina \
	RGPU=unit1 \
	RGSM=$2
	
rm /depot/bharpur/data/projects/keishi/bam_files/"2".bam
	
gatk MarkDuplicates\
	             I= /depot/bharpur/data/projects/keishi/updated_bam_files/"$2"_updated.bam \
	             O= /depot/bharpur/data/projects/keishi/final_bam_files/"$2"_final.bam \
	             M= marked_dup_metrics.  \
             	 REMOVE_SEQUENCING_DUPLICATES= true
             	 
rm /depot/bharpur/data/projects/keishi/updated_bam_files/"$2"_updated.bam
