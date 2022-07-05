#!/bin/sh
#FILENAME: 
#SBATCH -A bharpur
#SBATCH -n 1
#SBATCH --ntasks=1
#SBATCH -t 0-00:20:00

#var 1: fastq 1
#var 2: fastq 2
#var 3: run accesssion

#load modules
module load bioinfo
module load samtools
module load picard-tools/2.9.0
module load GATK

wget $1 -O /depot/bharpur/data/projects/keishi/fastq_files/"$3"_1.fastq.gz
wget $2 -O /depot/bharpur/data/projects/keishi/fastq_files/"$3"_2.fastq.gz

/depot/bharpur/apps/NextGenMap-0.5.2/bin/ngm-0.5.2/ngm -r /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna -1 /depot/bharpur/data/projects/keishi/fastq_files/"$3"_1.fastq.gz -2 /depot/bharpur/data/projects/keishi/fastq_files/"$3"_2.fastq.gz | samtools sort > /depot/bharpur/data/projects/keishi/bam_files/"$3".bam

rm /depot/bharpur/data/projects/keishi/fastq_files/"$3"_1.fastq.gz
rm /depot/bharpur/data/projects/keishi/fastq_files/"$3"_2.fastq.gz

java -jar $CLASSPATH AddOrReplaceReadGroups \
	I=/depot/bharpur/data/projects/keishi/bam_files/"$3".bam \
	O=/depot/bharpur/data/projects/keishi/updated_bam_files/"$3"_updated.bam \
	RGID=1 \
	RGLB=lib1 \
	RGPL=illumina \
	RGPU=unit1 \
	RGSM=$3

rm /depot/bharpur/data/projects/keishi/bam_files/"$3".bam

gatk MarkDuplicates\
	             I= /depot/bharpur/data/projects/keishi/updated_bam_files/"$3"_updated.bam \
	             O= /depot/bharpur/data/projects/keishi/final_bam_files/"$3"_final.bam \
	             M= marked_dup_metrics.  \
             	 REMOVE_SEQUENCING_DUPLICATES= true
             	 
rm /depot/bharpur/data/projects/keishi/updated_bam_files/"$3"_updated.bam
