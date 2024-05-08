#After we trimmed, we should be able to mapping our result to the Human reference Genome (or GRCh38, avaliable on NCBI, it is necessary to download it)

#We use bwa mem algorithm
#After the pipe (|) we get the unmapped reads!
#Replace {sample} with your file (in this case, paired-end)
bwa mem -t 16 -P /genomes/Homo_sapiens/GRCh38_latest_genomic.fna /QC/{sample}_R1_trimmed.fastq.gz /QC/{sample}_R2_trimmed.fastq.gz 
| samtools view -b -f 4 > /Unmapped/{sample}_unmapped.bam

count=$(samtools view -c /Unmapped/{sample}_unmapped.bam)
echo -e "There are $count unmapped reads!\n" #just in case tou wanna know how many reads are unmapped
