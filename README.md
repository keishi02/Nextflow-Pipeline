# Nextflow-Pipeline
Pipeline for genome alignment of apis mellifera

alignment_slurm_script.sh -> loads necessary modules, runs chmod +x to make scripts accesible, and calls alignment.py
alignment.py -> reads dataset, splits into two (1 ftp link and 1 ftp links). For all rows with 1 ftp link, it extracts the links and run accession, and passed them as variables to alignment_1_links.sh. The same is done for all rows with 2 links, but it calls alignment_2_links instead.
alignment_1_link -> 
