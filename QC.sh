#!/bin/bash
#quality control
#we use fastqc to analyse the quality the sequences before and after trimming
echo "Quality Control"
echo "FASTQC before"
fastqc path/to/files/*.fastq.gz -o /QC/Reports/before/
echo "Compile results - Multiqc"
multiqc /QC/Reports/before/
echo "Filtering and Trimming - fastp"
fastp -w 12 -i path/to/files/file.fastq.gz -o /QC/file_R1_trimmed.fastq.gz -I xxx_.fastq.gz -O QC/file_R2_trimmed.fastq.gz -q 30 -g -x -c -D -h /QC/Reports/fastp_report.html
echo "FASTQC after filtering and trimming"
fastqc /QC/*.fastq.gz -o /QC/Reports/after/
multiqc /QC/Reports/after/
