# Nextflow-Pipeline 
Pipeline for genome alignment of apis mellifera <br />

alignment_slurm_script.sh -> loads necessary modules, runs chmod +x to make scripts accesible, and calls alignment.py <br />

alignment.py -> reads dataset, splits into two (1 ftp link and 1 ftp links). For all rows with 1 ftp link, it extracts the links and run accession, and passed them as variables to alignment_1_links.sh. The same is done for all rows with 2 links, but it calls alignment_2_links instead. <br />

alignment_1_link -> loads modules, downloads fastq, performs ngm alignment + sorts and saves into bam file. Removes fastq file, then runs Add or Replace Groups and saves into new bam file before deleting old bam file. Marks duplicates and saves into new bam file before deleting previous bam file. You end up with one final bam file. <br />

alignment_2_links -> same as alignment_1_link but for rows with one link.


## After final bam files have been made:


post_bam.sh -> calls post_bam.py, which calls base_recalibration.sh and haplotype_caller.sh for every run accession
After running combine_gvcf.sh, variant_recalibration.sh, and finally variant_filtration.sh, you'll end up with AMELknown_sites.vcf
