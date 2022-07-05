# Nextflow-Pipeline
Pipeline for genome alignment of apis mellifera

alignment_slurm_script.sh -> loads necessary modules, runs chmod +x to make scripts accesible, and calls alignment.py
alignment.py -> reads dataset, splits into two (1 ftp link and 1 ftp links). For all rows with 1 ftp link, it extracts the links and run accession, and passed them as variables to alignment_1_links.sh. The same is done for all rows with 2 links, but it calls alignment_2_links instead.
alignment_1_link -> loads modules, downloads fastq, performs ngm alignment + sorts and saves into bam file. Removes fastq file, then runs Add or Replace Groups and saves into new bam file before deleting old bam file. Marks duplicates and saves into new bam file before deleting previous bam file. You end up with one final bam file.
alignment_2_links -> same as alignment_1_link but for rows with one link.
