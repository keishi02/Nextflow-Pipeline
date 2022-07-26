import pandas as pd
import subprocess
import sys
import glob

bamList = glob.glob("/depot/bharpur/data/projects/keishi/final_bam_files/*.bam")
for i in bamList:
    run_acc = i[i.rfind('/')+1:i.rfind('_')]
    subprocess.call(['/depot/bharpur/data/projects/keishi/base_recalibration.sh', run_acc])
    subprocess.call(['/depot/bharpur/data/projects/keishi/haplotype_caller.sh', run_acc])
    
