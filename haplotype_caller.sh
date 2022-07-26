#!/bin/sh
#FILENAME: haplotype_caller.sh
#SBATCH -A bharpur
#SBATCH -n 1
#SBATCH --ntasks=1
#SBATCH -t 3-0:00:00

module load bioinfo
module load GATK

#var1 = run accession

gatk HaplotypeCaller \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
	-I /depot/bharpur/data/projects/keishi/recal_bam_files/"$1"_recal_3.bam \
	-ERC GVCF \
	-O /depot/bharpur/data/projects/keishi/raw_snps/"$1"_raw_snps.vcf
	