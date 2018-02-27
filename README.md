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

