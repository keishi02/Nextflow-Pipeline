#!/bin/sh
#FILENAME: post_haplotype_caller.sh
#SBATCH -A bharpur
#SBATCH -n 1
#SBATCH --ntasks=1
#SBATCH -t 3-0:00:00

module load bioinfo
module load GATK
module load samtools
module load vcftools


#Split vcf files
for FILE in /depot/bharpur/data/projects/keishi/raw_snps/*.vcf
do
    vcf_in=$FILE
    vcf_out=/depot/bharpur/data/projects/keishi/split_vcf
    var="${FILE##*/}"
    var="${var%.*}"
    bgzip -c ${vcf_in} > ${vcf_in}.gz
    bcftools index ${vcf_in}.gz
    bcftools index -s ${vcf_in}.gz | cut -f 1 | while read C; do bcftools view -O v -o ${vcf_out}/${var}_split.${C}.vcf ${vcf_in}.gz "${C}" ; done
done
	
ls /depot/bharpur/data/projects/keishi/split_vcf/*.vcf > vcfs.list
	
#Combine GVCF
gatk CombineGVCFs \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
	--variant vcfs.list \
	-O /depot/bharpur/data/projects/keishi/cohort_g.vcf
	
#Genotype GVCF
gatk GenotypeGVCFs \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
	-V /depot/bharpur/data/projects/keishi/cohort_g.vcf \
	-O /depot/bharpur/data/projects/keishi/cohortGGVCF_g.vcf
	
#Variant Recalibration
gatk VariantRecalibrator -R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna -V /depot/bharpur/data/projects/keishi/cohortGGVCF_g.vcf --resource:hapmap,known=false,training=true,truth=true,prior=10 /depot/bharpur/data/ref_genomes/AMELknown_sites_snps.vcf -O out --tranches-file /depot/bharpur/data/projects/keishi/output.tranches --max-gaussians 1 -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP 
gatk ApplyVQSR -R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna -V /depot/bharpur/data/projects/keishi/cohortGGVCF_g.vcf -O /depot/bharpur/data/projects/keishi/output_snp.vcf -ts-filter-level 99.0 --tranches-file /depot/bharpur/data/projects/keishi/output.tranches --recal-file out -mode SNP
gatk VariantRecalibrator -R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna -V /depot/bharpur/data/projects/keishi/cohortGGVCF_g.vcf --resource:hapmap,known=false,training=true,truth=true,prior=10 /depot/bharpur/data/ref_genomes/AMELknown_sites_indels.vcf -O out --tranches-file /depot/bharpur/data/projects/keishi/output.tranches --max-gaussians 1 -an QD -an MQ -an MQRankSum -an ReadPosRankSum -an FS -an SOR -an DP 
gatk ApplyVQSR -R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna -V /depot/bharpur/data/projects/keishi/cohortGGVCF_g.vcf -O /depot/bharpur/data/projects/keishi/output_indel.vcf -ts-filter-level 99.0 --tranches-file /depot/bharpur/data/projects/keishi/output.tranches --recal-file out -mode INDEL	

#Variant Filtration
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

#Identify heterozygotic sites
vcftools --vcf /depot/bharpur/data/projects/keishi/all.filtered.vcf --hardy
grep [/][0][/] /depot/bharpur/data/projects/keishi/out.hwe | cut -f1,2  > homSNPList 

vcftools --vcf /depot/bharpur/data/projects/keishi/all.filtered.vcf --positions homSNPList --remove-filtered-all --recode --recode-INFO-all --out /depot/bharpur/data/projects/keishi/vcf.filt  --minGQ 20    
vcftools --vcf /depot/bharpur/data/projects/keishi/vcf.filt.recode.vcf --recode --recode-INFO-all --max-missing-count 5 --out /depot/bharpur/data/projects/keishi/vcf.filt2

mv /depot/bharpur/data/projects/keishi/vcf.filt2.recode.vcf /depot/bharpur/data/projects/keishi/AMELknown_sites.vcf
















	
	
	
	
	
	