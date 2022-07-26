#!/bin/sh
#FILENAME: post_bam.sh
#SBATCH -A bharpur
#SBATCH -n 1
#SBATCH --ntasks=1
#SBATCH -t 0-4:00:00

module load bioinfo
module load biopython/2.7/12

python /depot/bharpur/data/projects/keishi/post_bam.py