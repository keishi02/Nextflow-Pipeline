#!/bin/sh
#FILENAME: combine_gvcf.sh
#SBATCH -A bharpur
#SBATCH -n 1
#SBATCH --ntasks=1
#SBATCH -t 3-0:00:00

module load bioinfo
module load GATK

	
ls /depot/bharpur/data/projects/keishi/raw_snps/*.vcf > vcfs.list
	
gatk CombineGVCFs \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
	--variant vcfs.list \
	-O /depot/bharpur/data/projects/keishi/cohort_g.vcf
	
gatk GenotypeGVCFs \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
	-V /depot/bharpur/data/projects/keishi/cohort_g.vcf \
	-O /depot/bharpur/data/projects/keishi/cohortGGVCF_g.vcf
	


