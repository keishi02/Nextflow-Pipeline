#!/bin/sh
#FILENAME: variant_recalibration.sh
#SBATCH -A bharpur
#SBATCH -n 1
#SBATCH --ntasks=1
#SBATCH --mem=100G 
#SBATCH -t 3-0:00:00

module load bioinfo
module load GATK


gatk VariantRecalibrator -R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna -V /depot/bharpur/data/projects/keishi/cohortGGVCF_g.vcf --resource:hapmap,known=false,training=true,truth=true,prior=10 /depot/bharpur/data/ref_genomes/AMELknown_sites_snps.vcf -O out --tranches-file /depot/bharpur/data/projects/keishi/output.tranches --max-gaussians 1 -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP 

gatk ApplyVQSR -R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna -V /depot/bharpur/data/projects/keishi/cohortGGVCF_g.vcf -O /depot/bharpur/data/projects/keishi/output.vcf -ts-filter-level 99.0 --tranches-file /depot/bharpur/data/projects/keishi/output.tranches --recal-file out -mode SNP