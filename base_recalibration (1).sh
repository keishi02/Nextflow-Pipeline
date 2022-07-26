#!/bin/sh
#FILENAME: base_recalibration.sh
#SBATCH -A bharpur
#SBATCH -n 1
#SBATCH --ntasks=1
#SBATCH -t 0-4:00:00

module load bioinfo
module load GATK

#var1 = run accession

gatk BaseRecalibrator \
	-I /depot/bharpur/data/projects/keishi/final_bam_files/"$1"_final.bam \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
   --known-sites /depot/bharpur/data/ref_genomes/AMELknown_sites.vcf \
   -O /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_1.table


#ONE
gatk ApplyBQSR \
	-I /depot/bharpur/data/projects/keishi/final_bam_files/"$1"_final.bam \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
	--bqsr-recal-file /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_1.table \
	-O /depot/bharpur/data/projects/keishi/recal_bam_files/"$1"_recal_1.bam

gatk BaseRecalibrator \
	-I /depot/bharpur/data/projects/keishi/recal_bam_files/"$1"_recal_1.bam  \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
   --known-sites /depot/bharpur/data/ref_genomes/AMELknown_sites.vcf \
   -O /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_2.table
   
gatk AnalyzeCovariates \
	-before /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_1.table \
	-after /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_2.table \
	-plots /depot/bharpur/data/projects/keishi/recal_plots/"$1"_plot_1.pdf  
   
   
#TWO
gatk ApplyBQSR \
	-I /depot/bharpur/data/projects/keishi/recal_bam_files/"$1"_recal_1.bam \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
	--bqsr-recal-file /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_2.table \
	-O /depot/bharpur/data/projects/keishi/recal_bam_files/"$1"_recal_2.bam
	
gatk BaseRecalibrator \
	-I /depot/bharpur/data/projects/keishi/recal_bam_files/"$1"_recal_2.bam  \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
   --known-sites /depot/bharpur/data/ref_genomes/AMELknown_sites.vcf \
   -O /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_3.table
   
gatk AnalyzeCovariates \
	-before /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_1.table \
	-after /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_3.table \
	-plots /depot/bharpur/data/projects/keishi/recal_plots/"$1"_plot_2.pdf   
	
	
#THREE
gatk ApplyBQSR \
	-I /depot/bharpur/data/projects/keishi/recal_bam_files/"$1"_recal_2.bam \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
	--bqsr-recal-file /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_3.table \
	-O /depot/bharpur/data/projects/keishi/recal_bam_files/"$1"_recal_3.bam
	
gatk BaseRecalibrator \
	-I /depot/bharpur/data/projects/keishi/recal_bam_files/"$1"_recal_3.bam  \
	-R /depot/bharpur/data/ref_genomes/AMEL/Amel_HAv3.1_genomic.fna \
   --known-sites /depot/bharpur/data/ref_genomes/AMELknown_sites.vcf \
   -O /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_4.table
   
gatk AnalyzeCovariates \
	-before /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_1.table \
	-after /depot/bharpur/data/projects/keishi/data_tables/"$1"_recal_data_4.table \
	-plots /depot/bharpur/data/projects/keishi/recal_plots/"$1"_plot_3.pdf 

	
	
	
	
	