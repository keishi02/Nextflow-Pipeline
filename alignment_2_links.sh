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

wget $1 -O /depot/bharpur/data/projects/keishi/fastq_files/"$3"_1.fastq.gz
wget $2 -O /depot/bharpur/data/projects/keishi/fastq_files/"$3"_2.fastq.gz

/depot/bharpur/apps/NextGenMap-0.5.2/bin/ngm-0.5.2/ngm -r /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna -1 /depot/bharpur/data/projects/keishi/fastq_files/"$3"_1.fastq.gz -2 /depot/bharpur/data/projects/keishi/fastq_files/"$3"_2.fastq.gz -b -o /depot/bharpur/data/projects/keishi/bam_files/"$3".bam
#samtools view -bT /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna /depot/bharpur/data/projects/keishi/sam_files/"$3".sam > /depot/bharpur/data/projects/keishi/bam_files/"$3".bam

#rm /depot/bharpur/data/projects/keishi/sam_files/"$3".sam
rm /depot/bharpur/data/projects/keishi/fastq_files/"$3"_1.fastq.gz
rm /depot/bharpur/data/projects/keishi/fastq_files/"$3"_2.fastq.gz