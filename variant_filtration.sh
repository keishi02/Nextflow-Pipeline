#!/bin/sh
#FILENAME: variant_recalibration.sh
#SBATCH -A bharpur
#SBATCH -n 1
#SBATCH --ntasks=1
#SBATCH -t 3-0:00:00

module load bioinfo
module load vcftools
module load GATK

gatk VariantFiltration \
-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
--filter-expression "MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)" \
--filter-name HARD_TO_VALIDATE \
--filter-expression "FS>=10.0" \
--filter-name SNPSBFilter \
--filter-expression "DP<10" \
--filter-name SNPDPFilter \
-cluster 3 \
-window 0 \
-V /depot/bharpur/data/projects/keishi/output.vcf \
-O /depot/bharpur/data/projects/keishi/all.filtered.vcf

vcftools --vcf /depot/bharpur/data/projects/keishi/all.filtered.vcf --hardy
grep [/][0][/] /depot/bharpur/data/projects/keishi/out.hwe | cut -f1,2  > homSNPList 

vcftools --vcf /depot/bharpur/data/projects/keishi/all.filtered.vcf --positions homSNPList --remove-filtered-all --recode --recode-INFO-all --out /depot/bharpur/data/projects/keishi/vcf.filt  --minGQ 20    
vcftools --vcf /depot/bharpur/data/projects/keishi/vcf.filt.recode.vcf --recode --recode-INFO-all --max-missing-count 5 --out /depot/bharpur/data/projects/keishi/vcf.filt2

mv /depot/bharpur/data/projects/keishi/vcf.filt2.recode.vcf /depot/bharpur/data/projects/keishi/AMELknown_sites.vcf
