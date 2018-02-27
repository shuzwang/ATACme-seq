# ATACme-seq
# ATACme-seq Project
ATACme-seq is a high-throughput sequencing technique which could simultaneously measure chromatin accessibility and DNA methylation. This project contains the ATACme-seq analysis pipeline based on various bioinformatics software like FASTQC, CutAdapt, BWA-meth, etc. 
# ATACme-seq Analysis Pipeline
* [Introduction](#intro)
* [Basic quality checking with FastQC](#fastqc)
* [Trimming adapter sequence from reads](#trimming)
* [Aligning the trimmed reads to a reference genome](#aligning)
* [Calling peaks on the aligned reads](#callingpeaks)
* [Methylation calling on the aligned reads](#methylcalling)

## <a name="intro"></a>Introduction
We have 12 experiment setups divided by the doses of Tn5 (1/5x, 1x, 5x), sonication (sonicated, not sonicated), and bisulfite conversion (converted, not converted) for GM12878 cell line. We concentrated on the converted conditions, which are ```1/5x_sonicated_converted```, ```1/5x_not_sonicated_converted```, ```1x_sonicated_converted```, ```1x_not_sonicated_converted```,```5x_sonicated_converted```, ```5x_not_sonicated_converted```. For each condition, we only have one duplicate. 
Started from fastq files. The files look at this:
```@D00442:207:C97BPANXX:7:1109:1610:2067 1:N:0:ATTACTCG+TTTATGCCTT
NTCTATCACCCTATAGAAGAACTAATGTTAGTATAAGTAACATGAAAACATTCTCCTCCGCATAACCTTCCCAGATCGGAAGAGCACACGTCTGAACTCCAGTCACATTACT
+
#=<@BGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGDGGG
...```
