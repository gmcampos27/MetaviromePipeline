#!/bin/bash
#Now that we have everything unmapped, we need to classify then. Here we present 4 Taxonomic Classifiers
#All of then use 16 threads, but feel free to change this parameter
#Basically, you will use the unmapped file as input, and for output it will be generated a report that we move to /results folder
#The Database must be installed! It is easy to accomplish this step by reading user's manual for all 4 classifiers
echo -e "----------KRAKEN2-------------"
kraken2 -db /mnt/project2/database/kraken2/db/ --threads 16 --paired /mapping/file_unmapped.R1.fastq.gz /mapping/file_unmapped.R2.fastq.gz --report file_kraken.tsv
mv file_kraken.tsv /results
echo -e "\a\a\aDone, 1/4\a\a\a\n"
echo "-------------KAIJU------------"
kaiju -z 12 -t nodes.dmp -f kaiju_db_viruses.fmi -i file_unmapped.fastq.gz -o file_kaiju.out
kaiju2table -t nodes.dmp -n names.dmp -r species -u -e -o file_kaiju.tsv file_kaiju.out #convert to .tsv file or any other you like
mv file_kaiju.tsv /results
echo -e "\a\a\aDone, 2/4\a\a\a\n"
echo "----------DIAMOND------------"
echo "Database creation"
diamond makedb --in nr.gz --db nr #how to make a viruses database in Diamond
diamond blastx -d viruses.dmnd --verbose --outfmt 100 -q file_unmapped.fastq.gz -o file_diamond.daa
daa-meganizer -i file_diamond.daa -mdb megan-map-Jan2021.db #DIAMOND needs MEGAN to proper classify metagenome samples. Learn more in https://pubmed.ncbi.nlm.nih.gov/33656283/
echo -e "\a\a\aDone, 3/4\a\a\a\n"
echo "-------CLARK---------"
echo "Database creation"
echo bash ./download_RefSeq db viruses #how to make a viruses database in CLARK
echo bash ./set_targets db viruses
$echo bash ./classify_metagenome.sh -O file_unmapped.fastq.gz -R file_clark -n 16
$echo bash ./estimate_abundance.sh -F file_clark.csv -D db/viruses/
echo -e "\a\a\aDone, 4/4\a\a\a\n"
