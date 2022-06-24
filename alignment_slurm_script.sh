#!/bin/sh
#FILENAME: alignment.py
#SBATCH -A bharpur
#SBATCH -n 1
#SBATCH --ntasks=1
#SBATCH -t 0-05:00:00

#var1: how many rows of the genomic dataset to process OR "all" for all rows

module load bioinfo
module load biopython/2.7.12

chmod +x /depot/bharpur/data/projects/keishi/alignment_2_links.sh
chmod +x /depot/bharpur/data/projects/keishi/alignment_1_link.sh

python /depot/bharpur/data/projects/keishi/alignment.py $1