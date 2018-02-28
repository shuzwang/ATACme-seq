# ATACme-seq
# ATACme-seq Project
ATACme-seq is a high-throughput sequencing technique which could simultaneously measure chromatin accessibility and DNA methylation. This project contains the ATACme-seq analysis pipeline based on various bioinformatics software like FASTQC, CutAdapt, BWA-meth, etc. 
# ATACme-seq Analysis Pipeline
* [Introduction](#intro)
* [Setting up your workspace](#setup)
* [Basic quality checking with FastQC](#fastqc)
* [Trimming adapter sequence from reads](#trimming)
* [Aligning the trimmed reads to a reference genome](#aligning)
* [Calling peaks on the aligned reads](#callingpeaks)
* [Methylation calling on the aligned reads](#methylcalling)

## <a name="intro"></a>Introduction
We have 12 experiment setups divided by the doses of Tn5 (1/5x, 1x, 5x), sonication (sonicated, not sonicated), and bisulfite conversion (converted, not converted) for GM12878 cell line. We concentrated on the converted conditions, which are ```1/5x_sonicated_converted```, ```1/5x_not_sonicated_converted```, ```1x_sonicated_converted```, ```1x_not_sonicated_converted```,```5x_sonicated_converted```, ```5x_not_sonicated_converted```. For each condition, we only have one duplicate. Take 5x_sonicated_converted dataset as an example.

Started from fastq files. The files look at this:
```
@D00442:207:C97BPANXX:7:1109:1242:2112 1:N:0:AGCGATAG+GAATGGTCCC
GGGTATTTTTAATTTTAGAGTGAAAGTTTATAATTATTGTGTTTGTTTATAAGCCCCTAGATCGGAAGAGCACACGTCTGAACTCCAGTCACAGCGATAGATCTCGTATGCCGCCTTCTGCTTGAA
+
B?AB@GEFGGBGGGGGGGGGFCGG>FGGGGGEG<FGGGGGGFEGFG>GGGGGE>C0=EB@F:>0C<GBGEG0@=>>FGGFGGGGG0:FGGFGF>GG/CBFE@FGCGGGGDGGG.9CFCGGGGGG6:
@D00442:207:C97BPANXX:7:1109:1194:2120 1:N:0:AGCGATAG+GAATGGTCCC
ATATATAGTAGGTGGTATGAATTTAGGTATTTATATTTATATAATGATATTTTGTGATTTAGATTTAAAAAAGGTTTAATATTTTTAGTATTATTGGAAAATTTTAAATTTTTTGAAATNTTTTTT
+
...
```

## <a name="setup"></a>Setting up your workspace
Create a work directory and set a few environment variables to reduce typing later

```
export LAB_DIR=/nfs/kitzman3/users/shuzwang/atacme_analysis
cd $LAB_DIR
export LAB_DATA="/nfs/kitzman1/in_house_seq_runs/2016/core_hiseq/2016-06-01_PE125-10-10_Run_1563_PARKER/parker/Sample_63387_12"
export REF_DIR="/nfs/kitzman2/lab_common/alignment_index/bwameth-0.7/human/hs37d5"
```

## <a name="fastqc"></a>Basic quality checking with FastQC
Load FastQC software and run FastQc to check basic quality.

```
module load fastqc/0.11.5
fastqc -o ${LAB_DIR}/fastqc -f fastq ${LAB_DATA}/*.fastq.gz

```


## <a name="trimming"></a>Trimming adapter sequence from reads

## <a name="aligning"></a>Aligning the trimmed reads to a reference genome

Merge the trimmed reads and untrimmed reads for each experiment condition and then mark and remove duplicates. 
```
samtools merge GM12878__5x__SONICATED__CONVERTED.bam /nfs/kitzman2/jacob/proj/matac/round3core_160607/data/bybc/bwameth_hs37d5/s/GM12878__5x__SONICATED__CONVERTED_TRIMMED.bam /nfs/kitzman2/jacob/proj/matac/round3core_160607/data/bybc/bwameth_hs37d5/s/GM12878__5x__SONICATED__CONVERTED_UNTRIMMED.bam

java -jar /nfs/kitzman2/lab_software/linux_x86-64/picard-tools-1.141/picard.jar  MarkDuplicates METRICS_FILE=GM12878__5x__SONICATED__CONVERTED_dup.txt INPUT=/nfs/kitzman3/users/shuzwang/atacme/merged_atacme/GM12878__5x__SONICATED__CONVERTED.bam OUTPUT=/nfs/kitzman3/users/shuzwang/final/final_atacme/GM12878__5x__SONICATED__CONVERTED_md.bam ASSUME_SORTED=true CREATE_INDEX=true
```
## <a name="callingpeaks"></a>Calling peaks on the aligned reads

## <a name="methylcalling"></a>Methylation calling on the aligned reads
Using MethylDackel to call CpG sites.

```
MethylDackel extract -q 30 -p 30 -d 10 -@ 8 -o GM12878__5x__SONICATED__CONVERTED ~/reference_index/hs37d5.fa /nfs/kitzman3/users/shuzwang/final/md_atacme/GM12878__5x__SONICATED__CONVERTED_md.bam
```

# ATACme-seq Functional Analysis
* [Enrichment analysis](#enrichanalysis)
