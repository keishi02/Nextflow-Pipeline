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

wget $1 -O /depot/bharpur/data/projects/keishi/fastq_files/"$2".fastq.gz

/depot/bharpur/apps/NextGenMap-0.5.2/bin/ngm-0.5.2/ngm -r /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna -q /depot/bharpur/data/projects/keishi/fastq_files/"$2".fastq.gz -o /depot/bharpur/data/projects/keishi/sam_files/"$2".sam
samtools view -bT /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna /depot/bharpur/data/projects/keishi/sam_files/"$2".sam > /depot/bharpur/data/projects/keishi/bam_files/"$2".bam

rm /depot/bharpur/data/projects/keishi/sam_files/"$2".sam
rm /depot/bharpur/data/projects/keishi/fastq_files/"$2".fastq.gz