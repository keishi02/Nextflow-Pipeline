import pandas as pd
import subprocess
import shlex
import sys

#var1: how many rows of the genomic dataset to process OR "all" for all rows

df = pd.read_csv("/depot/bharpur/data/projects/keishi/genomics_dataset.csv")
df_mellifera = df[df["tax_id"] == 7460]

if (not sys.argv[1] == "all"):
    df_mellifera = df_mellifera.head(sys.argv[1])


df_mellifera1 = df_mellifera[df_mellifera["fastq_ftp"].str.contains(";")]
df_all = df_mellifera.merge(df_mellifera1.drop_duplicates(), on=['fastq_ftp'], how='left', indicator=True)
df_mellifera2 = df_all[df_all["_merge"] == "left_only"]


#for all samples with 2 ftp links
for i in range(len(df_mellifera1)):
    
    #first link
    var1 = df_mellifera1["fastq_ftp"].values[i].split(';')[0]
    
    #second link
    var2 = df_mellifera1["fastq_ftp"].values[i].split(';')[1]
    
    #run accession
    var3 = df_mellifera1["run_accession"].values[i]
    
    #call shell script
    subprocess.call(shlex.split('depot/bharpur/data/projects/keishi/alignment_2_links.sh {var1} {var2} {var3}'))


#for all samples with 1 ftp link  
for i in range(len(df_mellifera2)):
    
    #ftp link
    var1 = df_mellifera2["fastq_ftp"].values[i]
    
    #run accession
    var2 = df_mellifera2["run_accession"].values[i]
    
    #call shell script
    subprocess.call(shlex.split('depot/bharpur/data/projects/keishi/alignment_1_link.sh {var1} {var2}'))
    
    
    
    
    
    
    
    
    
    
    
    
    