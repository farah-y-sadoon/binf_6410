#!/bin/bash

#Usage: script2.sh <SRR accession>
#Example: script2.sh SRR20011368

mkdir -p ~/binf_class/lecture_08 && cd ~/binf_6410/lec_08

SRR=$1 #Capture first input
SRR1=$(echo $1 | cut -c1-3)
SRR2=$(echo $1 | cut -c4-6)
SRR3=$(echo $1 | cut -c7-9)
SRR4=$(echo $1 | cut -c10-11)

wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${SRR1}${SRR2}/0${SRR4}/${SRR}/${SRR}_1.fastq.gz && gunzip -f ${SRR}_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/${SRR1}${SRR2}/0${SRR4}/${SRR}/${SRR}_2.fastq.gz && gunzip -f ${SRR}_2.fastq.gz
vsearch --fastq_mergepairs ${SRR}_1.fastq --reverse ${SRR}_2.fastq  --fastqout ${SRR}_merged.fastq
wget https://ftp.ncbi.nlm.nih.gov/refseq/TargetedLoci/Fungi/fungi.ITS.fna.gz && gunzip -f fungi.ITS.fna.gz
vsearch --usearch_global ${SRR}_merged.fastq --db fungi.ITS.fna --blast6out ${SRR}_results.tsv --id 0.51 --maxhits 1 --notrunclabels
COUNTS=$(cut -f2 ${SRR}_results.tsv | cut -d' ' -f2-3 | sort | uniq -c | sort -n | grep 'Ascosphaera apis' | sed -E 's/ +/\t/g' | cut -f2)
echo -e "${SRR}\t${COUNTS}" #Print to stdout
echo -e "${SRR}\t${COUNTS}" > script2_output.tsv
