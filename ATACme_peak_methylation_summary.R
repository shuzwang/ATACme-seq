atacme_methylation_summary_per_peak = function(peakfile,methylation_calling,output_order = "ATACme_meanPercentMethylation"){
  library(GenomicRanges)
  library(tidyr)
  library(dplyr)
  
  # deal wity input datasets and convert them into GRanges for findOverlaps
  colnames(peakfile)[1:3] = c("chromosome","start","end")
  gr_peakfile = makeGRangesFromDataFrame(peakfile,keep.extra.columns = T,ignore.strand = T)
  
  colnames(methylation_calling)[1:3] = c("chromosome","start","end")
  gr_methylation_calling = makeGRangesFromDataFrame(methylation_calling,keep.extra.columns = T,ignore.strand = T)
  
  overlap_index = findOverlaps(gr_methylation_calling,gr_peakfile,type = "within",select = "all")
  overlap_index = as.data.frame(overlap_index)
  overlap_index$queryHits = as.character(overlap_index$queryHits)
  
  # summary the basic statistics for ATACme-seq
  queryhits_index = overlap_index$queryHits
  methylation_calling_subset = methylation_calling[queryhits_index,]
  methylation_calling_subset[,"queryHits"] = row.names(methylation_calling_subset)
  overlap_index_methylation = left_join(overlap_index,methylation_calling_subset,by = "queryHits")
  colnames(overlap_index_methylation)[6:8] = c("percentMethylation","numOfMethylated","numOfUnmethylated")
  overlap_index_methylation[,"coverage"] = overlap_index_methylation$numOfMethylated + overlap_index_methylation$numOfUnmethylated
  
  overlap_index_methylation$percentMethylation = as.numeric(overlap_index_methylation$percentMethylation)
  overlap_index_methylation$coverage = as.numeric(overlap_index_methylation$coverage)
  
  methylation_stats_per_peak = overlap_index_methylation %>% group_by(subjectHits) %>% 
    summarise(ATACme_meanCoverage = mean(coverage),ATACme_medianCoverage = median(coverage),ATACme_minCoverage = min(coverage),ATACme_maxCoverage = max(coverage),
              ATACme_meanPercentMethylation = mean(percentMethylation),ATACme_medianPercentMethylation = median(percentMethylation),ATACme_minPercentMethylation = min(percentMethylation),ATACme_maxPercentMethylation = max(percentMethylation))
  methylation_stats_per_peak$subjectHits = as.character(methylation_stats_per_peak$subjectHits)
  
  # generate a new data frame that record the basic statistics for each peak for ATACme-seq. The basic statistics include: #CpG sites, median/mean/min/max of coverage (depth) and % Methylation rate
  methylation_summary_df = peakfile[,1:3]
  methylation_summary_df[,"ATACme_numOfCpGs"] = countOverlaps(gr_peakfile,gr_methylation_calling)
  methylation_summary_df[,"subjectHits"] = row.names(methylation_summary_df)
  
  methylation_summary_output = left_join(methylation_summary_df,methylation_stats_per_peak,by = "subjectHits")
  
  # Sort the output data with certain order (the order could be defined in the argument)
  if(output_order == "ATACme_meanPercentMethylation"){
    methylation_summary_output= methylation_summary_output %>% arrange(desc(ATACme_meanPercentMethylation))
  }else if(output_order == "ATACme_numOfCpGs"){
    methylation_summary_output= methylation_summary_output %>% arrange(desc(ATACme_numOfCpGs))
  }else if(output_order == "ATACme_meanCoverage"){
    methylation_summary_output= methylation_summary_output %>% arrange(desc(ATACme_meanCoverage))
  }
  
  methylation_summary_output[,1] = sub("^","chr",methylation_summary_output[,1])
  autochrom = paste("chr",seq(1:22),sep = "")
  autochrom[23:24] = c("chrX","chrY")
  methylation_summary_output = methylation_summary_output[methylation_summary_output[,1] %in% autochrom,]
  
  return(methylation_summary_output)
}
