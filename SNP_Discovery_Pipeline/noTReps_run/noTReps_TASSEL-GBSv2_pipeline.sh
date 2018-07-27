#!/bin/sh

## July 20, 2018 run w/ default kmerLength, mnLCov, and mnMAF; changed default mnQS of 0 to
## value of 10; and NO technical replicates (i.e. with 45 technical replicates in Mock 
## plates REMOVED from the key file)

qrsh -N TASSEL -pe smp 5

###### WORKING DIRECTORY:
cd /gpfs_fs/home/jcbagley/compute/Aspen_Project/SNP_data/Mock-Strauss_TASSEL-GBSv2_ref_3_noTReps/


###### SETUP:
## MAKE DIRECTORY STRUCTURE (do in wkdir before run, place reference genome fasta file in ref/)
## mkdir fastq ref key db tagsToAlign hd5


###### RUN PIPELINE:
## GBSSeqToTagDBPlugin

/gpfs_fs/home/jcbagley/local/opt/tassel-5-standalone/run_pipeline.pl -Xmx10g -fork1 -GBSSeqToTagDBPlugin -i fastq -k key/Mock-Strauss_key_file.txt -e ApeKI -db db/Mock-Strauss.db -kmerLength 64 -mnQS 10 -endPlugin -runfork1

## TagExportToFastqPlugin
## Using default -c value of 1 here, but could increase to 5

/gpfs_fs/home/jcbagley/local/opt/tassel-5-standalone/run_pipeline.pl -Xmx10g -fork1 -TagExportToFastqPlugin -db db/Mock-Strauss.db -o tagsToAlign/tagsToAlign.fa.gz -c 1 -endPlugin -runfork1


## BWA alignment
## Index the genome:

cd ref;
bwa index -a bwtsw ./Potrs01b-genome.fa

## Align tags to genome:

bwa aln -t 5 ./Potrs01b-genome.fa ../tagsToAlign/tagsToAlign.fa.gz > ../tagsToAlign/tagsToAlign.sai
cd ..;

## Create single-ended alignment sam file (sam single-end, 'samse'):

bwa samse ref/Potrs01b-genome.fa tagsToAlign/tagsToAlign.sai tagsToAlign/tagsToAlign.fa.gz > tagsToAlign/tagsToAlign.sam


## SAMToGBSdbPlugin

/gpfs_fs/home/jcbagley/local/opt/tassel-5-standalone/run_pipeline.pl -Xmx10g -fork1 -SAMToGBSdbPlugin -i tagsToAlign/tagsToAlign.sam -db db/Mock-Strauss.db -aProp 0.0 -aLen 0 -minMAPQ 0 -endPlugin -runfork1


## DiscoverySNPCallerPluginV2
## Example with start and end chromosome numbers; these are not necessary/optional
## $ run_pipeline.pl -fork1 -DiscoverySNPCallerPluginV2 -db db/Tomato.db  -sC "chr00" -eC "chr12" -mnLCov 0.1 -mnMAF 0.01  -endPlugin -runfork1

/gpfs_fs/home/jcbagley/local/opt/tassel-5-standalone/run_pipeline.pl -Xmx10g -fork1 -DiscoverySNPCallerPluginV2 -db db/Mock-Strauss.db -mnLCov 0.1 -mnMAF 0.001 -endPlugin -runfork1


## ProductionSNPCallerPluginV2

/gpfs_fs/home/jcbagley/local/opt/tassel-5-standalone/run_pipeline.pl -Xmx10g -fork1 -ProductionSNPCallerPluginV2 -db db/Mock-Strauss.db -e ApeKI -i fastq -k key/Mock-Strauss_key_file.txt -kmerLength 64 -mnQS 0 -o finalProductionSNPs.vcf -endPlugin -runfork1




exit 0

